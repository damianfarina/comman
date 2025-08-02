module Sales
  class DashboardController < ApplicationController
    def index
      @confirmed_items = Sales::Order::Item.confirmed
      @in_progress_items = Sales::Order::Item.in_progress
      @ready_items = Sales::Order::Item.ready
      @delivered_items = Sales::Order::Item.delivered.where(updated_at: Date.today.all_day)

      @audit_logs = AuditLog
        .where(auditable_type: "Sales::Order")
        .or(AuditLog.where(auditable_type: "Sales::Order::Item"))
        .includes(:auditable, :user)
        .recent
    end
  end
end
