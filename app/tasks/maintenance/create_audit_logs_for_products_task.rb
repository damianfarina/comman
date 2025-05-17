# frozen_string_literal: true

module Maintenance
  class CreateAuditLogsForProductsTask < MaintenanceTasks::Task
    def collection
      Product.left_outer_joins(:audit_logs).where(audit_logs: { id: nil })
        .or(Product.left_outer_joins(:audit_logs).where.not(audit_logs: { action: "create" }))
        .distinct
    end

    def process(product)
      return if product.audit_logs.exists?(action: "create")

      AuditLog.create!(
        action: "create",
        auditable: product,
        audited_changes: { "_created" => [ nil, product.name ] },
        audited_fields: [ "_created" ],
        created_at: product.created_at,
        transaction_id: "created by maintenance task: #{self.class.name}",
        user_id: nil
      )
    end

    def count
      self.collection.count
    end
  end
end
