require "rails_helper"

RSpec.describe Sales::Order::Item, type: :model do
  let(:client) { create(:client) }
  let(:sales_order) { create(:sales_order, products_count: 1, client: client) }
  let(:product_with_price) { create(:purchased_productable, price: BigDecimal("100.50")) }

  describe "scopes" do
    let!(:item_quote) { create(:sales_order_item, order: sales_order, product: product_with_price, status: "quote", quantity: 1) }
    let!(:item_in_progress) { create(:sales_order_item, order: sales_order, product: product_with_price, status: "in_progress", quantity: 1) }
    let!(:item_ready) { create(:sales_order_item, order: sales_order, product: product_with_price, status: "ready", quantity: 1) }
    let!(:item_initially_with_valid_quantity) { create(:sales_order_item, order: sales_order, product: product_with_price, status: "quote", quantity: 1) }

    describe ".confirmable" do
      it "includes items in 'quote' status with a product and quantity > 0" do
        expect(Sales::Order::Item.confirmable).to include(item_quote)
      end

      it "excludes items not in 'quote' status" do
        expect(Sales::Order::Item.confirmable).not_to include(item_in_progress)
      end

      it "excludes items with quantity 0 or less" do
        item_initially_with_valid_quantity.update_column(:quantity, 0)
        expect(Sales::Order::Item.confirmable).not_to include(item_initially_with_valid_quantity)
      end
    end

    describe ".in_progress" do
      it "includes items in 'in_progress' status" do
        expect(Sales::Order::Item.in_progress).to include(item_in_progress)
        expect(Sales::Order::Item.in_progress).not_to include(item_quote)
      end
    end

    describe ".deliverable" do
      it "includes items in 'in_progress' or 'ready' status" do
        expect(Sales::Order::Item.deliverable).to include(item_in_progress, item_ready)
        expect(Sales::Order::Item.deliverable).not_to include(item_quote)
      end
    end
  end

  describe "validations" do
    subject { build(:sales_order_item, order: sales_order, product: product_with_price) }

    context "for quantity" do
      it "is valid when quantity is greater than 0" do
        subject.quantity = 1
        expect(subject).to be_valid
      end

      it "is invalid when quantity is 0" do
        subject.quantity = 0
        expect(subject).not_to be_valid
        expect(subject.errors[:quantity]).to include("debe ser mayor que 0")
      end

      it "is invalid when quantity is negative" do
        subject.quantity = -1
        expect(subject).not_to be_valid
        expect(subject.errors[:quantity]).to include("debe ser mayor que 0")
      end

      it "is invalid when quantity is not a number" do
        subject.quantity = "abc"
        expect(subject).not_to be_valid
        expect(subject.errors[:quantity]).to include("no es un número")
      end
    end

    context "for unit_price" do
      it "is valid when unit_price is greater than or equal to 0" do
        subject.unit_price = BigDecimal("10.0")
        expect(subject).to be_valid
        subject.unit_price = BigDecimal("0")
        expect(subject).to be_valid
      end

      it "is invalid when unit_price is negative" do
        subject.unit_price = BigDecimal("-1.0")
        expect(subject).not_to be_valid
        expect(subject.errors[:unit_price]).to include("debe ser mayor o igual que 0")
      end

      it "is valid when unit_price is nil (due to allow_nil)" do
        subject.unit_price = nil
        expect(subject).to be_valid
      end

      it "is invalid when unit_price is not a number" do
        item = build(:sales_order_item, unit_price: "abc")
        expect(item).not_to be_valid
        expect(item.errors[:unit_price]).to include("no es un número")
      end
    end

    context "for status" do
      it "is invalid when status is nil" do
        subject.status = nil
        expect(subject).not_to be_valid
        expect(subject.errors[:status]).to include("no puede estar en blanco", "no está incluido en la lista")
      end

      it "is invalid when status is an empty string" do
        subject.status = ""
        expect(subject).not_to be_valid
        expect(subject.errors[:status]).to include("no está incluido en la lista")
      end

      it "raises an ArgumentError when assigning an invalid status string" do
        expect { subject.status = "invalid_status" }.to raise_error(ArgumentError)
      end

      Sales::Order::Item.statuses.each_value do |valid_status|
        it "is valid when status is '#{valid_status}'" do
          subject.status = valid_status
          expect(subject).to be_valid
        end
      end
    end
  end

  describe "#effective_unit_price" do
    context "when item has a unit_price set" do
      it "returns the item's unit_price" do
        item = build(:sales_order_item, unit_price: BigDecimal("50.25"), product: product_with_price)
        expect(item.effective_unit_price).to eq(BigDecimal("50.25"))
      end
    end

    context "when item unit_price is blank and product has a price" do
      it "returns the product's price" do
        item = build(:sales_order_item, unit_price: nil, product: product_with_price)
        expect(item.effective_unit_price).to eq(product_with_price.price)
      end
    end

    context "when item unit_price is blank and product is nil" do
      it "returns nil" do
        item = build(:sales_order_item, unit_price: nil, product: nil)
        expect(item.effective_unit_price).to be_nil
      end
    end
  end

  describe "#subtotal" do
    it "calculates unit_price * quantity" do
      item = build(:sales_order_item, unit_price: BigDecimal("10.0"), quantity: 3, product: product_with_price)
      expect(item.subtotal).to eq(BigDecimal("30.0"))
    end

    it "uses effective_unit_price if unit_price is nil" do
      item = build(:sales_order_item, unit_price: nil, product: product_with_price, quantity: 2)
      expect(item.subtotal).to eq(product_with_price.price * 2)
    end

    it "returns BigDecimal('0') if effective_unit_price is nil (e.g. product is nil and item.unit_price is nil)" do
      item = build(:sales_order_item, unit_price: nil, product: nil, quantity: 2)
      expect(item.subtotal).to eq(BigDecimal("0"))
    end

    it "returns BigDecimal('0') if quantity is nil" do
      item = build(:sales_order_item, unit_price: BigDecimal("10.0"), quantity: nil, product: product_with_price)
      expect(item.subtotal).to eq(BigDecimal("0"))
    end

    it "returns BigDecimal('0') if both effective_unit_price (due to nil product) and quantity are nil" do
      item = build(:sales_order_item, unit_price: nil, product: nil, quantity: nil)
      expect(item.subtotal).to eq(BigDecimal("0"))
    end
  end

  describe "#can_confirm?" do
    it "returns true if status is 'quote', product is present, and quantity > 0" do
      item = build(:sales_order_item, status: "quote", product: product_with_price, quantity: 1)
      expect(item.can_confirm?).to be true
    end

    it "returns false if status is not 'quote'" do
      item = build(:sales_order_item, status: "in_progress", product: product_with_price, quantity: 1)
      expect(item.can_confirm?).to be false
    end

    it "returns false if product is not present" do
      item = build(:sales_order_item, status: "quote", product: nil, quantity: 1)
      expect(item.can_confirm?).to be false
    end

    it "returns false if quantity is 0" do
      item = build(:sales_order_item, status: "quote", product: product_with_price, quantity: 0)
      expect(item.can_confirm?).to be false
    end

    it "returns false if quantity is nil" do
      item = build(:sales_order_item, status: "quote", product: product_with_price, quantity: nil)
      expect(item.can_confirm?).to be false
    end
  end

  describe "#confirm!" do
    let(:item) { create(:sales_order_item, order: sales_order, product: product_with_price, status: "quote", quantity: 2, unit_price: nil) }

    context "when item can be confirmed" do
      before do
        allow(item).to receive(:can_confirm?).and_return(true)
      end

      it "sets unit_price to effective_unit_price (product price if item unit_price is blank)" do
        item.confirm!
        expect(item.unit_price).to eq(product_with_price.price)
      end

      it "keeps existing unit_price if already set" do
        item_with_price = create(:sales_order_item, order: sales_order, product: product_with_price, status: "quote", quantity: 1, unit_price: BigDecimal("99.0"))
        allow(item_with_price).to receive(:can_confirm?).and_return(true)
        item_with_price.confirm!
        expect(item_with_price.unit_price).to eq(BigDecimal("99.0"))
      end

      it "sets unit_price to BigDecimal('0') if effective_unit_price is nil (e.g. product is nil and item.unit_price is nil)" do
        item_with_nil_product = build(:sales_order_item,
                                      order: sales_order,
                                      product: nil,
                                      status: "quote",
                                      quantity: 1,
                                      unit_price: nil)
        allow(item_with_nil_product).to receive(:can_confirm?).and_return(true)
        allow(item_with_nil_product).to receive(:save!).and_return(true)
        item_with_nil_product.confirm!
        expect(item_with_nil_product.unit_price).to eq(BigDecimal("0"))
      end

      it "changes status to 'confirmed'" do
        item.confirm!
        expect(item.status).to eq("confirmed")
      end

      it "saves the item" do
        expect(item).to receive(:save!)
        item.confirm!
      end
    end

    context "when item cannot be confirmed" do
      it "raises a StandardError" do
        allow(item).to receive(:can_confirm?).and_return(false)
        expect { item.confirm! }.to raise_error(StandardError, "Sales::Order::Item not in a confirmable state.")
      end
    end
  end

  describe "#split!" do
    let(:item) { create(:sales_order_item, order: sales_order, product: product_with_price, quantity: 2, status: :in_progress) }

    context "when splitting is valid" do
      it "creates a new sales order item with the specified quantity" do
        new_item = item.split!(1)
        expect(new_item).to be_persisted
        expect(new_item.quantity).to eq(1)
      end

      it "reduces the quantity of the original item" do
        item.split!(1)
        expect(item.reload.quantity).to eq(1)
      end

      it "sets the status of the new item to 'confirmed'" do
        new_item = item.split!(1)
        expect(item.status).to eq("in_progress")
        expect(new_item.status).to eq("confirmed")
      end
    end

    context "when splitting is invalid" do
      it "does not create a new sales order item if quantity is invalid" do
        new_item = item.split!(3)
        expect(new_item).not_to be_persisted
      end

      it "adds an error to the original item if quantity is invalid" do
        item.split!(3)
        expect(item.errors.added?(:base, :split_quantity_invalid)).to be true
      end
    end
  end

  describe "#work_on!" do
    let(:item) do
      create(:sales_order_item,
        order: sales_order,
        product: product_with_price,
        status: "confirmed",
        quantity: 2,
        unit_price: 10,
      )
    end

    context "when item can be marked as in_progress" do
      it "changes status to 'in_progress'" do
        item.work_on!
        expect(item.reload.status).to eq("in_progress")
      end
    end

    context "when item cannot be marked as in_progress" do
      before do
        item.update(status: "canceled")
      end

      it "sets an error on the model" do
        item.work_on!
        expect(item.errors.added?(:base, :in_progress_invalid)).to be true
        expect(item.status).to eq("canceled")
      end
    end
  end

  describe "#can_deliver?" do
    it "returns true if status is 'in_progress'" do
      item = build(:sales_order_item, status: "in_progress", product: product_with_price)
      expect(item.can_deliver?).to be true
    end

    it "returns true if status is 'ready'" do
      item = build(:sales_order_item, status: "ready", product: product_with_price)
      expect(item.can_deliver?).to be true
    end

    it "returns false if status is 'quote'" do
      item = build(:sales_order_item, status: "quote", product: product_with_price)
      expect(item.can_deliver?).to be false
    end

    it "returns false if status is 'delivered'" do
      item = build(:sales_order_item, status: "delivered", product: product_with_price)
      expect(item.can_deliver?).to be false
    end

    it "returns false if status is 'canceled'" do
      item = build(:sales_order_item, status: "canceled", product: product_with_price)
      expect(item.can_deliver?).to be false
    end
  end

  describe "#deliver!" do
    let(:item) { create(:sales_order_item, order: sales_order, product: product_with_price, status: "ready") }

    context "when item can be delivered" do
      it "changes status to 'delivered'" do
        item.deliver!
        expect(item.status).to eq("delivered")
      end

      it "saves the item" do
        expect(item).to receive(:save!)
        item.deliver!
      end
    end

    context "when item cannot be delivered" do
      before do
        item.update(status: "canceled")
      end

      it "sets an error on the model" do
        item.deliver!
        expect(item.errors.added?(:base, :delivery_invalid)).to be true
        expect(item.status).to eq("canceled")
      end
    end
  end

  describe "#can_cancel?" do
    it "returns true if status is not canceled or delivered" do
      item_quote = build(:sales_order_item, status: "quote", product: product_with_price, quantity: 1)
      expect(item_quote.can_cancel?).to be true
      item_confirmed = build(:sales_order_item, status: "confirmed", product: product_with_price, quantity: 1)
      expect(item_confirmed.can_cancel?).to be true
      item_in_progress = build(:sales_order_item, status: "in_progress", product: product_with_price, quantity: 1)
      expect(item_in_progress.can_cancel?).to be true
      item_ready = build(:sales_order_item, status: "ready", product: product_with_price, quantity: 1)
      expect(item_ready.can_cancel?).to be true
      item_delivered = build(:sales_order_item, status: "delivered", product: product_with_price, quantity: 1)
      expect(item_delivered.can_cancel?).to be false
      item_canceled = build(:sales_order_item, status: "canceled", product: product_with_price, quantity: 1)
      expect(item_canceled.can_cancel?).to be false
    end
  end

  describe "#resolved?" do
    it "returns true if status is 'delivered'" do
      item = build(:sales_order_item, status: "delivered", product: product_with_price)
      expect(item.resolved?).to be true
    end

    it "returns true if status is 'canceled'" do
      item = build(:sales_order_item, status: "canceled", product: product_with_price)
      expect(item.resolved?).to be true
    end

    it "returns false if status is 'in_progress'" do
      item = build(:sales_order_item, status: "in_progress", product: product_with_price)
      expect(item.resolved?).to be false
    end
  end

  describe "#current_unit_price" do
    it "returns product.price if product and price exist" do
      item = build(:sales_order_item, product: product_with_price)
      expect(item.current_unit_price).to eq(product_with_price.price)
    end

    it "returns nil if product is nil" do
      item = build(:sales_order_item, product: nil)
      expect(item.current_unit_price).to be_nil
    end
  end

  describe "#audit_name" do
    it "returns formatted string with product name and quantity" do
      item = build(:sales_order_item, product: product_with_price, quantity: 3)
      expect(item.audit_name).to eq("#{product_with_price.name} (3)")
    end

    it "handles nil product name" do
      allow(product_with_price).to receive(:name).and_return(nil)
      item = build(:sales_order_item, product: product_with_price, quantity: 2)
      expect(item.audit_name).to eq("N/A (2)")
    end

    it "handles nil product" do
      item = build(:sales_order_item, product: nil, quantity: 2)
      expect(item.audit_name).to eq("N/A (2)")
    end

    it "handles nil quantity" do
      item = build(:sales_order_item, product: product_with_price, quantity: nil)
      expect(item.audit_name).to eq("#{product_with_price.name} (0)")
    end
  end
end
