# frozen_string_literal: true

require "rails_helper"

module Maintenance
  RSpec.describe CreateAuditLogsForClientsTask do
    describe "#collection" do
      let!(:record_created_at) { DateTime.parse("2023-10-01 06:31:00") }
      let!(:client1) do
        Auditable.without_auditing do
          create(:client,
            name: "Test Client",
            client_type: :regular,
            tax_identification: "123456",
            tax_type: :final_consumer,
            created_at: record_created_at,
          )
        end
      end

      let(:client2) do
        Auditable.without_auditing do
          create(:client,
            name: "Another Client",
            client_type: :distributor,
            tax_identification: "654321",
            tax_type: :general_regime,
            created_at: record_created_at,
          )
        end
      end

      it "collects clients without audit logs" do
        client2.assign_attributes(name: "Updated Client")
        Auditable.with_auditing { client2.save! }
        client3 = Auditable.with_auditing do
          create(:client,
            name: "Last Client",
            client_type: :hardware_store,
            tax_identification: "999999",
            tax_type: :simplified_regime,
            created_at: record_created_at,
          )
        end
        expect(described_class.collection).not_to include(client3)
        expect(described_class.collection).to contain_exactly(client1, client2)
      end
    end

    describe "#process" do
      let!(:record_created_at) { DateTime.parse("2023-10-01 06:31:00") }
      let!(:client1) do
        Auditable.without_auditing do
          create(:client,
            name: "Test Client",
            client_type: :regular,
            tax_identification: "123456",
            tax_type: :final_consumer,
            created_at: record_created_at,
          )
        end
      end

      it "creates an audit log for the client1" do
        allow(Time).to receive(:current).and_return(record_created_at)
        expect { described_class.process(client1) }.to change(AuditLog, :count).by(1)
        expect(AuditLog.last).to have_attributes(
          action: "create",
          auditable: client1,
          audited_changes: { "_created" => [ nil, client1.name ] },
          audited_fields: [ "_created" ],
          created_at: record_created_at,
          transaction_id: "created by maintenance task: Maintenance::CreateAuditLogsForClientsTask",
          user_id: nil,
        )
      end

      it "sets created_at to the client's created_at" do
        allow(Time).to receive(:current).and_return(record_created_at)
        described_class.process(client1)
        expect(AuditLog.last.created_at).to eq(record_created_at)
      end

      it "does not create duplicate audit logs" do
        described_class.process(client1)
        described_class.process(client1)
        expect(client1.audit_logs.where(action: "create").size).to eq(1)
      end
    end
  end
end
