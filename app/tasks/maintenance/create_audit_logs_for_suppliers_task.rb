# frozen_string_literal: true

module Maintenance
  class CreateAuditLogsForSuppliersTask < MaintenanceTasks::Task
    def collection
      Supplier.left_outer_joins(:audit_logs)
        .where(audit_logs: { id: nil })
        .or(Supplier.where.not(audit_logs: { action: "create" }))
        .distinct
    end

    def process(supplier)
      return if supplier.audit_logs.exists?(action: "create")

      AuditLog.create!(
        action: "create",
        auditable: supplier,
        audited_changes: { "_created" => [ nil, supplier.name ] },
        audited_fields: [ "_created" ],
        created_at: supplier.created_at,
        transaction_id: "created by maintenance task: #{self.class.name}",
        user_id: nil
      )
    end

    def count
      self.collection.count
    end
  end
end
