module Sales
  class DashboardController < ApplicationController
    def index
      @audit_logs = AuditLog
        .where(auditable_type: "Sales::Order")
        .or(AuditLog.where(auditable_type: "Sales::Order::Item"))
        .includes(:auditable, :user)
        .recent
    end
  end
end
