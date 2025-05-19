require "rails_helper"

# This spec uses the Product model to verify Auditable concern behavior
RSpec.describe "Auditable", type: :model do
  let(:user) { create(:user) }

  around do |example|
    Auditable.with_auditing do
      example.run
    end
  end

  before do
    allow(Current).to receive(:user).and_return(user)
    allow(Current).to receive(:request_id) { SecureRandom.uuid }
  end

  describe "#audit_changes_raw" do
    context "when record is updated" do
      let(:product) { create(:product, name: "Old", price: 100, productable: build(:purchased_product)) }

      it "returns the changed fields and values for attributes" do
        product.update!(name: "New")

        audit_log = product.audit_logs.recent.first
        changes = audit_log.audited_changes
        fields = audit_log.audited_fields

        expect(changes).to include("name" => [ "Old", "New" ])
        expect(fields).to include("name")
      end
    end

    context "when record is destroyed" do
      let(:product) { create(:product, name: "ToDelete", productable: build(:purchased_product)) }

      it "returns _destroyed change" do
        product.destroy!

        audit_log = AuditLog.recent.find_by(auditable: product)
        changes = audit_log.audited_changes
        fields = audit_log.audited_fields

        expect(changes).to include("_destroyed" => [ "ToDelete", nil ])
        expect(fields).to include("_destroyed")
      end
    end

    context "when record is created" do
      it "returns _created change only" do
        product = create(:product, name: "New Product", price: 50, productable: build(:purchased_product))

        audit_log = product.audit_logs.recent.first
        changes = audit_log.audited_changes
        fields = audit_log.audited_fields


        expect(changes).to eq({ "_created" => [ nil, "New Product" ] })
        expect(fields).to eq([ "_created" ])
      end
    end

    context "when has_many/has_one associated records are changed (via nested attributes)" do
      let(:supplier1) { create(:supplier, name: "Supplier One") }
      let(:supplier2) { create(:supplier, name: "Supplier Two") }
      let(:supplier3) { create(:supplier, name: "Supplier Three") }
      let(:product) { create(:product, name: "Test Product", productable: build(:purchased_product)) }
      let!(:supplier_product_to_delete) do
        create(:supplier_product, product: product, supplier: supplier1, code: "DEL", price: 9.0)
      end
      let!(:supplier_product_to_update) do
        create(:supplier_product, product: product, supplier: supplier2, code: "X1", price: 10.0)
      end

      it "tracks creation, update, and deletion of supplied_by" do
        product.reload.assign_attributes(
          supplied_by_attributes: [
            { id: supplier_product_to_update.id, price: 12.0 }, # Update existing
            { id: supplier_product_to_delete.id, _destroy: true }, # Mark for destruction
            { supplier_id: supplier3.id, price: 8.0, code: "NEW" }, # Create new
          ]
        )
        product.save!

        audit_log = product.audit_logs.recent.first
        changes = audit_log.audited_changes
        fields = audit_log.audited_fields

        expect(changes["supplied_by.#{supplier_product_to_update.id}.price"]).to eq([ "10.0", "12.0" ])
        expect(fields).to include("supplied_by.price")

        created_supplier_product = product.supplied_by.find_by(code: "NEW")
        expect(created_supplier_product).to be_present
        expect(changes["supplied_by.#{created_supplier_product.id}._created"])
          .to eq([ nil, created_supplier_product.audit_name ])
        expect(fields).to include("supplied_by._created")

        expect(changes["supplied_by.#{supplier_product_to_delete.id}._destroyed"])
          .to eq([ supplier_product_to_delete.audit_name, nil ])
        expect(fields).to include("supplied_by._destroyed")
      end
    end

    context "when belongs_to association is changed" do
      let(:supplier1) { create(:supplier, name: "Supplier One") }
      let(:supplier2) { create(:supplier, name: "Supplier Two") }
      let(:product_with_supplier) do
        create(
          :product,
          name: "Audited Product",
          productable: build(:purchased_product),
          supplied_by: [
            build(:supplier_product, supplier: supplier1),
            build(:supplier_product, supplier: supplier2),
          ],
          supplier: supplier1,
        ).reload
      end
      let(:product_without_supplier) do
        create(:product, name: "Audited Product 2", productable: build(:purchased_product)).reload
      end


      it "logs the change from one associated record to another using audit_name" do
        product_with_supplier.update!(supplier: supplier2)

        audit_log = product_with_supplier.audit_logs.recent.first
        changes = audit_log.audited_changes
        fields = audit_log.audited_fields

        expect(changes["supplier"]).to eq([ supplier1.audit_name, supplier2.audit_name ])
        expect(fields).to include("supplier")
      end

      it "logs the change from an associated record to nil using audit_name" do
        product_with_supplier.assign_attributes(supplied_by: [], supplier: nil)
        product_with_supplier.save!

        audit_log = product_with_supplier.audit_logs.recent.first
        changes = audit_log.audited_changes
        fields = audit_log.audited_fields

        expect(changes["supplier"]).to eq([ supplier1.audit_name, nil ])
        expect(fields).to include("supplier")
      end

      it "logs the change from nil to an associated record using audit_name" do
        product_without_supplier.assign_attributes(
          supplied_by_attributes: [ { supplier_id: supplier1.id, price: 10.0, code: "NEW" } ],
          supplier_id: supplier1.id,
        )
        product_without_supplier.save!

        supplier_product = product_without_supplier.supplied_by.first
        audit_log = product_without_supplier.audit_logs.recent.first
        changes = audit_log.audited_changes
        fields = audit_log.audited_fields

        expect(changes["supplier"]).to eq([ nil, supplier1.audit_name ])
        expect(changes["supplied_by.#{supplier_product.id}._created"])
          .to eq([ nil, "#{supplier_product.audit_name}" ])
        expect(fields).to include("supplier")
      end

      it "does not log a change if the belongs_to association does not change" do
        product_with_supplier.update!(name: "New Name")

        audit_log = product_with_supplier.audit_logs.recent.first
        changes = audit_log.audited_changes
        fields = audit_log.audited_fields

        expect(changes).not_to have_key("supplier")
        expect(fields).not_to include("supplier")
        expect(changes).to have_key("name")
      end
    end
  end

  describe "Auditable.without_auditing" do
    let!(:product) { create(:product, name: "Initial Name", productable: build(:purchased_product)) }

    it "suppresses audit logging within the block" do
      expect {
        Auditable.without_auditing do
          product.update!(name: "Suppressed Change")
          product.destroy!
        end
      }.not_to change { AuditLog.count }
    end

    it "resumes audit logging after the block" do
      audit_logs_count = AuditLog.count

      Auditable.without_auditing do
        product.update!(name: "Suppressed Change")
      end

      # Ensure no audit log was created for the suppressed change
      expect(AuditLog.count).to eq(audit_logs_count)

      # Make a change outside the suppress block
      expect {
        product.update!(name: "Unsuppressed Change")
      }.to change { AuditLog.count }.by(1)

      # Verify the log for the unsuppressed change
      audit_log = product.audit_logs.recent.first
      expect(audit_log.action).to eq("update")
      expect(audit_log.audited_changes).to include("name" => [ "Suppressed Change", "Unsuppressed Change" ])
    end

    it "restores the original suppression state even if an error occurs" do
      ActiveSupport::IsolatedExecutionState[:auditing_suppressed] = false
      audit_logs_count = AuditLog.count

      expect {
        Auditable.without_auditing do
          product.update!(name: "Suppressed Change")
          raise "Something went wrong"
        end
      }.to raise_error("Something went wrong")

      expect(AuditLog.count).to eq(audit_logs_count)

      expect(ActiveSupport::IsolatedExecutionState[:auditing_suppressed]).to eq(false)

      expect {
        product.update!(name: "Unsuppressed Change After Error")
      }.to change { AuditLog.count }.by(1)
    end
  end
end
