require "rails_helper"

# This spec uses the Product model to verify Auditable concern behavior
RSpec.describe "Auditable", type: :model do
  let(:user) { create(:user) }

  before do
    allow(Current).to receive(:user).and_return(user)
    allow(Current).to receive(:request_id) { SecureRandom.uuid }
  end

  describe "#audit_changes_raw" do
    context "when record is updated" do
      let(:product) { create(:product, name: "Old", price: 100, productable: build(:purchased_product)) }

      it "returns the changed fields and values" do
        product.update!(name: "New")

        raw = product.audit_changes_raw

        expect(raw["audited_changes"]).to include("name" => [ "Old", "New" ])
        expect(raw["audited_fields"]).to include("name")
      end
    end

    context "when record is destroyed" do
      let(:product) { create(:product, name: "ToDelete", productable: build(:purchased_product)) }

      it "returns _destroyed change" do
        product.destroy!
        raw = product.audit_changes_raw

        expect(raw["audited_changes"]).to include("_destroyed" => [ "ToDelete", nil ])
        expect(raw["audited_fields"]).to include("_destroyed")
      end
    end

    context "when record is created" do
      it "returns _created change only" do
        product = create(:product, name: "New Product", price: 50, productable: build(:purchased_product))
        raw = product.audit_changes_raw

        expect(raw["audited_changes"]).to eq({ "_created" => [ nil, "New Product" ] })
        expect(raw["audited_fields"]).to eq([ "_created" ])
      end
    end

    context "when associated records are changed" do
      let(:supplier1) { create(:supplier, name: "Supplier One") }
      let(:supplier2) { create(:supplier, name: "Supplier Two") }
      let(:supplier3) { create(:supplier, name: "Supplier Three") }
      let(:product1) { create(:product, name: "Test Product", productable: build(:purchased_product)) }
      let!(:supplier_product_to_delete) { create(:supplier_product, product: product1, supplier: supplier1, code: "DEL", price: 9.0) }
      let!(:supplier_product_to_update) { create(:supplier_product, product: product1, supplier: supplier2, code: "X1", price: 10.0) }

      it "tracks creation, update, and deletion of supplied_by" do
        product = Product.find(product1.id)
        product.assign_attributes(
          supplied_by_attributes: [
            { id: supplier_product_to_update.id, price: 12.0 },
            { id: supplier_product_to_delete.id, _destroy: true },
            { supplier_id: supplier3.id, price: 8.0, code: "NEW" },
          ]
        )
        product.save!

        audit_log = product.audit_logs.recent.first
        changes = audit_log.audited_changes
        fields = audit_log.audited_fields

        expect(changes["supplied_by.#{supplier_product_to_update.id}.price"]).to eq([ "10.0", "12.0" ])
        expect(fields).to include("supplied_by.price")

        created = product.supplied_by.order(:id).last
        expect(changes["supplied_by.#{created.id}._created"]).to eq([ nil, "Supplier Three (NEW - 8.0)" ])
        expect(fields).to include("supplied_by._created")

        expect(changes["supplied_by.#{supplier_product_to_delete.id}._destroyed"]).to eq([ "Supplier One (DEL - 9.0)", nil ])
        expect(fields).to include("supplied_by._destroyed")
      end
    end
  end
end
