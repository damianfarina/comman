require 'rails_helper'

RSpec.describe ActivityFeedHelper, type: :helper do
  let(:user) { build(:user, name: "John Doe") }
  let(:client) { build(:client, name: "Test Client") }
  let(:sales_order) { build(:sales_order, products_count: 1, client: client) }

  describe "#activity_change_value" do
    context "with blank values" do
      it "returns nil for empty string" do
        expect(helper.activity_change_value(sales_order, :name, "")).to be_nil
      end

      it "returns nil for nil" do
        expect(helper.activity_change_value(sales_order, :name, nil)).to be_nil
      end

      it "returns false for false boolean" do
        expect(helper.activity_change_value(sales_order, :active, false)).to eq(I18n.t("auditable.boolean_false"))
      end
    end

    context "with enum values" do
      it "returns translated enum value" do
        result = helper.activity_change_value(sales_order, :status, "confirmed")
        expect(result).to eq(I18n.t("activerecord.attributes.sales_order.status_values.confirmed"))
      end

      it "falls back to string value for untranslated enums" do
        result = helper.activity_change_value(sales_order, :status, "nonexistent_status")
        expect(result).to eq("nonexistent_status")
      end
    end

    context "with boolean values" do
      it "returns translated true value" do
        result = helper.activity_change_value(sales_order, :active, true)
        expect(result).to eq(I18n.t("auditable.boolean_true"))
      end

      it "returns translated false value" do
        result = helper.activity_change_value(sales_order, :active, false)
        expect(result).to eq(I18n.t("auditable.boolean_false"))
      end
    end

    context "with price attributes" do
      it "formats price fields as currency" do
        result = helper.activity_change_value(sales_order, :total_price, 1250.75)
        expect(result).to eq("$1.250,75")
      end

      it "handles unit_price fields" do
        product_with_price = create(:purchased_productable, price: BigDecimal("100.50"))
        sales_order_item = create(:sales_order_item, sales_order: sales_order, product: product_with_price)
        result = helper.activity_change_value(sales_order_item, :unit_price, 99.99)
        expect(result).to eq("$99,99")
      end

      it "handles string price values" do
        result = helper.activity_change_value(sales_order, :total_price, "1000.50")
        expect(result).to eq("$1.000,50")
      end
    end

    context "with date/time values" do
      let(:date_value) { Date.new(2025, 7, 24) }
      let(:time_value) { Time.new(2025, 7, 24, 15, 30, 0) }
      let(:datetime_value) { DateTime.new(2025, 7, 24, 15, 30, 0) }

      before do
        allow(sales_order.class).to receive(:type_for_attribute).with(:created_at).and_return(
          double(type: :datetime)
        )
        allow(sales_order.class).to receive(:type_for_attribute).with(:date_field).and_return(
          double(type: :date)
        )
        allow(sales_order.class).to receive(:type_for_attribute).with(:time_field).and_return(
          double(type: :time)
        )
      end

      it "formats date values" do
        result = helper.activity_change_value(sales_order, :date_field, date_value)
        expect(result).to eq(I18n.l(date_value, format: :short))
      end

      it "formats time values" do
        result = helper.activity_change_value(sales_order, :time_field, time_value)
        expect(result).to eq(I18n.l(time_value, format: :short))
      end

      it "formats datetime values" do
        result = helper.activity_change_value(sales_order, :created_at, datetime_value)
        expect(result).to eq(I18n.l(datetime_value, format: :short))
      end
    end

    context "with regular string values" do
      it "returns string representation" do
        result = helper.activity_change_value(sales_order, :comments_plain_text, "Some comment")
        expect(result).to eq("Some comment")
      end

      it "converts numbers to strings" do
        result = helper.activity_change_value(sales_order, :id, 123)
        expect(result).to eq("123")
      end
    end
  end

  describe "#activity_event" do
    it "returns translated event name" do
      result = helper.activity_event("create")
      expect(result).to eq(I18n.t("auditable.events.create", default: "Create"))
    end

    it "falls back to humanized string for untranslated events" do
      result = helper.activity_event("custom_action")
      expect(result).to eq("Custom action")
    end

    it "handles symbol events" do
      result = helper.activity_event(:update)
      expect(result).to eq(I18n.t("auditable.events.update", default: "Update"))
    end
  end

  describe "#link_to_auditable" do
    context "when polymorphic path exists" do
      before do
        allow(Current).to receive(:department).and_return(:sales)
        allow(helper).to receive(:polymorphic_path).with([ :sales, sales_order ]).and_return("/sales/orders/1")
        allow(sales_order).to receive(:audit_name).and_return("Sales Order #123")
      end

      it "returns link to auditable object" do
        result = helper.link_to_auditable(sales_order)
        expect(result).to include('href="/sales/orders/1"')
        expect(result).to include("Sales Order #123")
      end

      it "passes through additional options" do
        result = helper.link_to_auditable(sales_order, class: "custom-class", target: "_blank")
        expect(result).to include('class="custom-class"')
        expect(result).to include('target="_blank"')
      end
    end

    context "when polymorphic path fails" do
      before do
        allow(Current).to receive(:department).and_return(:sales)
        allow(helper).to receive(:polymorphic_path).and_raise(ActionController::UrlGenerationError)
        allow(sales_order).to receive(:audit_name).and_return("Sales Order #123")
      end

      it "returns span with audit name" do
        result = helper.link_to_auditable(sales_order)
        expect(result).to include("<span>Sales Order #123</span>")
        expect(result).not_to include("href")
      end
    end

    context "when audit_name is not available" do
      let(:object_without_audit_name) { double("Object") }

      before do
        allow(Current).to receive(:department).and_return(:sales)
        allow(helper).to receive(:polymorphic_path).and_raise(ActionController::UrlGenerationError)
        allow(object_without_audit_name).to receive(:audit_name).and_raise(NoMethodError)
      end

      it "handles missing audit_name gracefully" do
        expect {
          helper.link_to_auditable(object_without_audit_name)
        }.to raise_error(NoMethodError)
      end
    end
  end

  describe "#auditable_field_name" do
    it "returns translated field name" do
      result = helper.auditable_field_name(sales_order, "total_price")
      expect(result).to eq(I18n.t("activerecord.attributes.sales_order.total_price"))
    end

    it "handles nested field names" do
      result = helper.auditable_field_name(sales_order, "client.name")
      expect(result).to eq(I18n.t("activerecord.attributes.sales_order.client"))
    end

    it "handles complex field paths" do
      result = helper.auditable_field_name(sales_order, "sales_order_items.product.name")
      expect(result).to eq(I18n.t("activerecord.attributes.sales_order.sales_order_items"))
    end
  end

  describe "#auditable_type_name" do
    it "returns translated model name" do
      result = helper.auditable_type_name(sales_order)
      expected = I18n.t(
        :sales_order,
        scope: [ :activerecord, :models ],
        count: 1,
        default: "Sales order"
      )
      expect(result).to eq(expected)
    end

    it "falls back to humanized class name" do
      custom_object = double("CustomObject", class: double(name: "CustomObject"))
      result = helper.auditable_type_name(custom_object)
      expected = "Customobject"
      expect(result).to eq(expected)
    end
  end

  describe "#activity_user_name" do
    it "returns user name when user is present" do
      result = helper.activity_user_name(user)
      expect(result).to eq("John Doe")
    end

    it "returns translated unknown user when user is nil" do
      result = helper.activity_user_name(nil)
      expect(result).to eq(I18n.t("auditable.unknown_user"))
    end

    it "returns translated unknown user when user name is blank" do
      user.name = ""
      result = helper.activity_user_name(user)
      expect(result).to eq(I18n.t("auditable.unknown_user"))
    end

    it "returns translated unknown user when user name is nil" do
      user.name = nil
      result = helper.activity_user_name(user)
      expect(result).to eq(I18n.t("auditable.unknown_user"))
    end
  end

  describe "integration with different model types" do
    let(:product) { create(:purchased_productable) }
    let(:supplier) { create(:supplier) }

    it "works with different auditable models" do
      # Test with User model
      result = helper.activity_change_value(user, :name, "Jane Doe")
      expect(result).to eq("Jane Doe")

      # Test with Product model
      result = helper.activity_change_value(product, :name, "Test Product")
      expect(result).to eq("Test Product")

      # Test with Supplier model
      result = helper.activity_change_value(supplier, :name, "Test Supplier")
      expect(result).to eq("Test Supplier")
    end

    it "handles price formatting across different models" do
      # Product price
      result = helper.activity_change_value(product, :price, 150.00)
      expect(result).to eq("$150,00")

      # Sales order total price
      result = helper.activity_change_value(sales_order, :total_price, 1500.00)
      expect(result).to eq("$1.500,00")
    end
  end

  describe "edge cases and error handling" do
    it "handles objects without defined_enums method" do
      object_without_enums = double("Object", class: double)
      allow(object_without_enums.class).to receive(:respond_to?).with(:defined_enums).and_return(false)
      allow(object_without_enums.class).to receive(:type_for_attribute).with(:status).and_return(double(type: :string))

      result = helper.activity_change_value(object_without_enums, :status, "active")
      expect(result).to eq("active")
    end

    it "handles zero values correctly" do
      result = helper.activity_change_value(sales_order, :total_price, 0)
      expect(result).to eq("$0,00")
    end
  end
end
