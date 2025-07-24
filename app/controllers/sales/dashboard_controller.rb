module Sales
  class DashboardController < ApplicationController
    def index
      @audit_logs = AuditLog
        .where(auditable_type: "SalesOrder")
        .or(AuditLog.where(auditable_type: "SalesOrderItem"))
        .includes(:auditable, :user)
        .recent
    end
  end
end
