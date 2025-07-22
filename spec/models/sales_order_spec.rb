require "rails_helper"

RSpec.describe SalesOrder, type: :model do
  let!(:client) { create(:client) }
  let!(:product1) { create(:purchased_productable, name: "Product A", price: 100.00) }
  let!(:product2) { create(:purchased_productable, name: "Product B", price: 50.00) }

  describe "associations" do
    it "belongs to a client" do
      order = build(:sales_order, client: nil)
      expect(order).not_to be_valid
      expect(order.errors[:client]).to include("debe existir")
    end

    it "has many sales_order_items" do
      order = create(:sales_order, client: client, sales_order_items: [
        build(:sales_order_item, product: product1, quantity: 1, unit_price: product1.price),
        build(:sales_order_item, product: product2, quantity: 1, unit_price: product2.price),
      ])
      item1 = order.sales_order_items[0]
      item2 = order.sales_order_items[1]
      expect(order.sales_order_items.count).to eq(2)
      expect(order.sales_order_items).to include(item1, item2)
    end

    it "destroys associated sales_order_items when destroyed" do
      order = create(:sales_order, client: client, sales_order_items: [
        build(:sales_order_item, product: product1, quantity: 1, unit_price: product1.price),
        build(:sales_order_item, product: product2, quantity: 1, unit_price: product2.price),
      ])
      expect { order.destroy }.to change(SalesOrderItem, :count).by(-2)
    end

    it "has many products through sales_order_items" do
      order = create(:sales_order, client: client, sales_order_items: [
        build(:sales_order_item, product: product1, quantity: 1, unit_price: product1.price),
        build(:sales_order_item, product: product2, quantity: 1, unit_price: product2.price),
      ])
      expect(order.products).to include(product1, product2)
      expect(order.products.count).to eq(2)
    end
  end

  describe "validations" do
    subject { build(:sales_order, client: client, sales_order_items: [
      build(:sales_order_item, product: product1, quantity: 1, unit_price: product1.price),
    ]) }

    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is invalid without a client" do
      subject.client = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:client]).to include("debe existir")
    end

    it "is invalid without products" do
      subject.sales_order_items = []
      expect(subject).not_to be_valid
      expect(subject.errors[:sales_order_items]).to include("no puede estar en blanco")
    end

    context "for discounts" do
      it "is valid when between 0 and 100" do
        subject.cash_discount_percentage = 0
        subject.client_discount_percentage = 0
        expect(subject).to be_valid

        subject.cash_discount_percentage = 50.5
        subject.client_discount_percentage = 50.5
        expect(subject).to be_valid

        subject.cash_discount_percentage = 100
        subject.client_discount_percentage = 100
        expect(subject).to be_valid

        subject.cash_discount_percentage = -0.1
        subject.client_discount_percentage = -0.1
        expect(subject).not_to be_valid
        expect(subject.errors[:cash_discount_percentage]).to include("debe ser mayor o igual que 0")
        expect(subject.errors[:client_discount_percentage]).to include("debe ser mayor o igual que 0")

        subject.cash_discount_percentage = 100.1
        subject.client_discount_percentage = 100.1
        expect(subject).not_to be_valid
        expect(subject.errors[:cash_discount_percentage]).to include("debe ser menor o igual que 100")
        expect(subject.errors[:client_discount_percentage]).to include("debe ser menor o igual que 100")
      end
    end

    context "for total_price" do
      it "is valid when greater than, equal to 0 or nil" do
        subject.total_price = 100.00
        expect(subject).to be_valid
        subject.total_price = 0
        expect(subject).to be_valid
        subject.total_price = nil
        expect(subject).to be_valid

        subject.total_price = -1.00
        expect(subject).not_to be_valid
        expect(subject.errors[:total_price]).to include("debe ser mayor o igual que 0")
      end
    end

    context "for status" do
      it "is invalid when status is nil or empty" do
        subject.status = nil
        expect(subject).not_to be_valid
        expect(subject.errors[:status]).to include("no puede estar en blanco", "no está incluido en la lista")
        subject.status = ""
        expect(subject).not_to be_valid
        expect(subject.errors[:status]).to include("no está incluido en la lista")

        expect { subject.status = "invalid_status" }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#can_confirm?" do
    let!(:order) { create(:sales_order, products_count: 1, client: client, status: "quote") }

    context "when order is a quote" do
      it "returns true if it has confirmable items with valid prices" do
        create(:sales_order_item, sales_order: order, product: product1, quantity: 1, status: "quote", unit_price: product1.price)
        expect(order.can_confirm?).to be true
      end

      it "returns false if it has no items" do
        order.sales_order_items.destroy_all
        expect(order.can_confirm?).to be false
      end

      it "returns false if confirmable items have no effective price" do
        create(:sales_order_item, sales_order: order, product: product1, quantity: 1, status: "quote", unit_price: nil)
        allow_any_instance_of(SalesOrderItem).to receive(:effective_unit_price).and_return(nil)
        expect(order.can_confirm?).to be false
      end
    end

    it "returns false if order is not a 'quote'" do
      order.update!(status: "confirmed")
      expect(order.can_confirm?).to be false
    end
  end

  describe "#confirm!" do
    let!(:order) { create(:sales_order, client: client, status: "quote", client_discount_percentage: 10.0, sales_order_items: [
      build(:sales_order_item, product: product1, quantity: 2, status: "quote", unit_price: nil),
      build(:sales_order_item, product: product2, quantity: 1, status: "quote", unit_price: 40.00),
    ]) }
    let!(:item1) { order.sales_order_items.first }
    let!(:item2) { order.sales_order_items.second }

    context "when order can be confirmed" do
      before do
        allow(order).to receive(:can_confirm?).and_return(true)
      end

      it "changes order status to 'confirmed'" do
        expect { order.confirm! }.to change { order.status }.from("quote").to("confirmed")
      end

      it "sets confirmed_at timestamp" do
        order.confirm!
        expect(order.confirmed_at).to be_within(1.second).of(Time.current)
      end

      it "updates items to 'confirmed' and freezes their prices" do
        order.confirm!
        expect(item1.reload.status).to eq("confirmed")
        expect(item1.unit_price).to eq(product1.price)
        expect(item2.reload.status).to eq("confirmed")
        expect(item2.unit_price).to eq(40.00)
      end

      it "calculates and sets total_price correctly" do
        order.confirm!
        expected_total = 216.00
        expect(order.total_price).to eq(expected_total)
      end

      it "returns true" do
        expect(order.confirm!).to be true
      end
    end

    context "when order cannot be confirmed" do
      before do
        allow(order).to receive(:can_confirm?).and_return(false)
      end

      it "returns false and adds a combined error message" do
        expect(order.confirm!).to be false
        base_error_start = I18n.t("activerecord.errors.models.sales_order.attributes.base.confirmation_failed", details: "")
        precondition_error = I18n.t("activerecord.errors.models.sales_order.not_confirmable")
        final_error = order.errors[:base].first
        expect(final_error).to start_with(base_error_start.strip)
        expect(final_error).to include(precondition_error)
      end
    end

    context "when an item fails to confirm" do
      before do
        allow(order).to receive(:can_confirm?).and_return(true)
        allow_any_instance_of(SalesOrderItem).to receive(:confirm!).and_raise(ActiveRecord::RecordInvalid.new(item1))
      end

      it "rolls back the transaction and adds the correct I18n error" do
        expect(order.confirm!).to be false
        expect(order.reload.status).to eq("quote")
        expect(order.errors[:base].first).to start_with(I18n.t("activerecord.errors.models.sales_order.attributes.base.confirmation_failed", details: "").strip)
      end
    end
  end

  describe "#cancel!" do
    let(:order) { create(:sales_order, products_count: 1, client: client, status: "confirmed") }

    context "when order can be canceled" do
      before { allow(order).to receive(:can_cancel?).and_return(true) }

      it "changes status to 'canceled'" do
        expect { order.cancel! }.to change { order.status }.to("canceled")
      end

      it "sets canceled_at" do
        order.cancel!
        expect(order.canceled_at).to be_within(1.second).of(Time.current)
      end
    end

    context "when order cannot be canceled" do
      before { allow(order).to receive(:can_cancel?).and_return(false) }

      it "returns false and adds a combined error message" do
        expect(order.cancel!).to be false
        precondition_error = I18n.t("activerecord.errors.models.sales_order.not_cancellable")
        base_error_start = I18n.t("activerecord.errors.models.sales_order.attributes.base.cancellation_failed", details: "")
        final_error = order.errors[:base].first
        expect(final_error).to start_with(base_error_start.strip)
        expect(final_error).to include(precondition_error)
      end
    end
  end

  describe "#can_fulfill?" do
    it "returns true if status is 'confirmed'" do
      expect(build(:sales_order, status: "confirmed").can_fulfill?).to be true
    end

    it "returns false if status is not 'confirmed'" do
      expect(build(:sales_order, status: "quote").can_fulfill?).to be false
      expect(build(:sales_order, status: "fulfilled").can_fulfill?).to be false
      expect(build(:sales_order, status: "canceled").can_fulfill?).to be false
    end
  end

  describe "#fulfill!" do
    let!(:order) { create(:sales_order, client: client, status: "confirmed", sales_order_items: [
      build(:sales_order_item, product: product1, status: "in_progress"),
    ]) }
    let!(:item_in_progress) { order.sales_order_items.first }

    context "when order can be fulfilled" do
      before { allow(order).to receive(:can_fulfill?).and_return(true) }

      it "changes order status to 'fulfilled'" do
        expect { order.fulfill! }.to change { order.status }.to("fulfilled")
        expect(order.fulfilled_at).to be_within(1.second).of(Time.current)
        expect(item_in_progress.reload.status).to eq("delivered")
      end
    end

    context "when order cannot be fulfilled" do
      before { allow(order).to receive(:can_fulfill?).and_return(false) }

      it "returns false and adds a combined error message" do
        expect(order.fulfill!).to be false
        base_error_start = I18n.t("activerecord.errors.models.sales_order.attributes.base.fulfillment_failed", details: "")
        precondition_error = I18n.t("activerecord.errors.models.sales_order.not_fulfillable")
        final_error = order.errors[:base].first
        expect(final_error).to start_with(base_error_start.strip)
        expect(final_error).to include(precondition_error)
      end
    end
  end

  describe "#subtotal_before_order_discount" do
    it "returns the sum of subtotals for not-canceled items" do
      order = create(:sales_order, client: client, status: "confirmed", sales_order_items: [
        build(:sales_order_item, product: product1, quantity: 2, status: "in_progress", unit_price: 10),
        build(:sales_order_item, product: product2, quantity: 1, status: "canceled", unit_price: 20),
        build(:sales_order_item, product: product2, quantity: 2, status: "quote", unit_price: 5),
        build(:sales_order_item, product: product2, quantity: 1, status: "ready", unit_price: 5),
        build(:sales_order_item, product: product2, quantity: 1, status: "delivered", unit_price: 5),
      ])
      expect(order.subtotal_before_order_discount).to eq(2*10 + 2*5 + 1*5 + 1*5)
    end
  end

  describe "#subtotal_after_order_discount" do
    it "returns subtotal_before_order_discount minus client_discount_value" do
      order = create(:sales_order, client: client, status: "confirmed", client_discount_percentage: 10.0, sales_order_items: [
        build(:sales_order_item, product: product1, quantity: 2, status: "in_progress", unit_price: 100),
      ])
      expected_subtotal = 2*100
      expected_discount = expected_subtotal * 0.10
      expect(order.subtotal_after_order_discount).to eq(expected_subtotal - expected_discount)
    end
  end

  describe "#client_discount_value" do
    it "returns 0 if client_discount_percentage is blank or 0" do
      order = build(:sales_order, client: client, client_discount_percentage: nil, sales_order_items: [ build(:sales_order_item, product: product1, quantity: 1, status: "in_progress", unit_price: 100) ])
      expect(order.client_discount_value).to eq(0)
      order.client_discount_percentage = 0
      expect(order.client_discount_value).to eq(0)
    end

    it "returns the correct discount value if present and > 0" do
      order = build(:sales_order, client: client, client_discount_percentage: 25, sales_order_items: [ build(:sales_order_item, product: product1, quantity: 2, status: "in_progress", unit_price: 100) ])
      expect(order.client_discount_value).to eq(200 * 0.25)
    end
  end

  describe "#cash_discount_value" do
    it "returns 0 if cash_discount_percentage is blank or 0" do
      order = build(:sales_order, client: client, cash_discount_percentage: nil, client_discount_percentage: 0, sales_order_items: [ build(:sales_order_item, product: product1, quantity: 1, status: "in_progress", unit_price: 100) ])
      expect(order.cash_discount_value).to eq(0)
      order.cash_discount_percentage = 0
      expect(order.cash_discount_value).to eq(0)
    end

    it "returns the correct cash discount value if present and > 0" do
      order = build(:sales_order, client: client, client_discount_percentage: 10, cash_discount_percentage: 5, sales_order_items: [ build(:sales_order_item, product: product1, quantity: 2, status: "in_progress", unit_price: 100) ])
      subtotal = 200
      client_discount = subtotal * 0.10
      subtotal_after = subtotal - client_discount
      expect(order.cash_discount_value).to eq(subtotal_after * 0.05)
    end
  end
end
