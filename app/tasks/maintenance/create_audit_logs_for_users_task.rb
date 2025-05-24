# frozen_string_literal: true

module Maintenance
  class CreateAuditLogsForUsersTask < MaintenanceTasks::Task
    def collection
      User.left_outer_joins(:audit_logs)
        .where(audit_logs: { id: nil })
        .or(User.where.not(audit_logs: { action: "create" }))
        .distinct
    end

    def process(user)
      return if user.audit_logs.exists?(action: "create")

      AuditLog.create!(
        action: "create",
        auditable: user,
        audited_changes: { "_created" => [ nil, user.name ] },
        audited_fields: [ "_created" ],
        created_at: user.created_at,
        transaction_id: "created by maintenance task: #{self.class.name}",
        user_id: nil
      )
    end

    def count
      self.collection.count
    end
  end
end
