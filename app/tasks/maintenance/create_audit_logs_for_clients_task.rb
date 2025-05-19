# frozen_string_literal: true

module Maintenance
  class CreateAuditLogsForClientsTask < MaintenanceTasks::Task
    def collection
      Client.left_outer_joins(:audit_logs)
        .where(audit_logs: { id: nil })
        .or(Client.where.not(audit_logs: { action: "create" }))
        .distinct
    end

    def process(client)
      return if client.audit_logs.exists?(action: "create")

      AuditLog.create!(
        action: "create",
        auditable: client,
        audited_changes: { "_created" => [ nil, client.name ] },
        audited_fields: [ "_created" ],
        created_at: client.created_at,
        transaction_id: "created by maintenance task: #{self.class.name}",
        user_id: nil
      )
    end

    def count
      self.collection.count
    end
  end
end
