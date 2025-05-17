module Factory
  class DashboardController < ApplicationController
    def index
      @audit_logs = AuditLog
        .where(auditable_type: "Product", auditable_id: Product.manufactured_products.select(:id))
        .includes(:auditable, :user)
        .recent
    end
  end
end
