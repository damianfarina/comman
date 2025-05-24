# frozen_string_literal: true

require "rails_helper"

module Maintenance
  RSpec.describe CreateAuditLogsForUsersTask do
    describe "#collection" do
      let!(:record_created_at) { DateTime.parse("2023-10-01 06:31:00") }
      let!(:user1) do
        Auditable.without_auditing do
          create(:user,
            name: "Test User",
            created_at: record_created_at,
          )
        end
      end

      let!(:user2) do
        Auditable.without_auditing do
          create(:user,
            name: "Another User",
            created_at: record_created_at,
          )
        end
      end

      it "collects users without audit logs" do
        user2.assign_attributes(name: "Updated User")
        Auditable.with_auditing { user2.save! }
        user3 = Auditable.with_auditing do
          create(:user,
            name: "Last User",
            created_at: record_created_at,
          )
        end
        expect(described_class.collection).not_to include(user3)
        expect(described_class.collection).to contain_exactly(user1, user2)
      end
    end

    describe "#process" do
      let!(:record_created_at) { DateTime.parse("2023-10-01 06:31:00") }
      let!(:user1) do
        Auditable.without_auditing do
          create(:user,
            name: "Test User",
            created_at: record_created_at,
          )
        end
      end

      it "creates an audit log for the user1" do
        allow(Time).to receive(:current).and_return(record_created_at)
        expect { described_class.process(user1) }.to change(AuditLog, :count).by(1)
        expect(AuditLog.last).to have_attributes(
          action: "create",
          auditable: user1,
          audited_changes: { "_created" => [ nil, user1.name ] },
          audited_fields: [ "_created" ],
          created_at: record_created_at,
          transaction_id: "created by maintenance task: Maintenance::CreateAuditLogsForUsersTask",
          user_id: nil,
        )
      end

      it "sets created_at to the user's created_at" do
        allow(Time).to receive(:current).and_return(record_created_at)
        described_class.process(user1)
        expect(AuditLog.last.created_at).to eq(record_created_at)
      end

      it "does not create duplicate audit logs" do
        described_class.process(user1)
        described_class.process(user1)
        expect(user1.audit_logs.where(action: "create").size).to eq(1)
      end
    end
  end
end
