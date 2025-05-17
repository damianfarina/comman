module Office
  class DashboardController < ApplicationController
    def index
      @audit_logs = AuditLog.recent.includes(:auditable, :user)
    end
  end
end
