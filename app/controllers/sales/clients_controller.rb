module Sales
  class ClientsController < ApplicationController
    include IdSearchQueryProcessor

    # GET /sales/clients or /sales/clients.json
    def index
      @q = Client.with_last_sales_order_at.ransack(params[:q])
      @q.sorts = default_sort if @q.sorts.empty?
      @clients = @q.result.page(params[:page])
    end

    private

    def default_sort
      [ "name asc" ]
    end
  end
end
