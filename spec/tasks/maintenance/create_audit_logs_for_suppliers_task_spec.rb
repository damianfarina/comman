# frozen_string_literal: true

require "rails_helper"

module Maintenance
  RSpec.describe CreateAuditLogsForSuppliersTask do
    describe "#collection" do
      let!(:record_created_at) { DateTime.parse("2023-10-01 06:31:00") }
      let!(:supplier1) do
        Auditable.without_auditing do
          create(:supplier,
            name: "Test Supplier",
            created_at: record_created_at,
          )
        end
      end

      let(:supplier2) do
        Auditable.without_auditing do
          create(:supplier,
            name: "Another Supplier",
            created_at: record_created_at,
          )
        end
      end

      it "collects suppliers without audit logs" do
        supplier2.assign_attributes(name: "Updated Supplier")
        Auditable.with_auditing { supplier2.save! }
        supplier3 = Auditable.with_auditing do
          create(:supplier,
            name: "Last Supplier",
            created_at: record_created_at,
          )
        end
        expect(described_class.collection).not_to include(supplier3)
        expect(described_class.collection).to contain_exactly(supplier1, supplier2)
      end
    end

    describe "#process" do
      let!(:record_created_at) { DateTime.parse("2023-10-01 06:31:00") }
      let!(:supplier1) do
        Auditable.without_auditing do
          create(:supplier,
            name: "Test Supplier",
            created_at: record_created_at,
          )
        end
      end

      it "creates an audit log for the supplier1" do
        allow(Time).to receive(:current).and_return(record_created_at)
        expect { described_class.process(supplier1) }.to change(AuditLog, :count).by(1)
        expect(AuditLog.last).to have_attributes(
          action: "create",
          auditable: supplier1,
          audited_changes: { "_created" => [ nil, supplier1.name ] },
          audited_fields: [ "_created" ],
          created_at: record_created_at,
          transaction_id: "created by maintenance task: Maintenance::CreateAuditLogsForSuppliersTask",
          user_id: nil,
        )
      end

      it "sets created_at to the supplier's created_at" do
        allow(Time).to receive(:current).and_return(record_created_at)
        described_class.process(supplier1)
        expect(AuditLog.last.created_at).to eq(record_created_at)
      end

      it "does not create duplicate audit logs" do
        described_class.process(supplier1)
        described_class.process(supplier1)
        expect(supplier1.audit_logs.where(action: "create").size).to eq(1)
      end
    end
  end
end
