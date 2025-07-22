module Sales
  module SalesOrders
    class DeliveriesController < ApplicationController
      before_action :set_sales_order
      before_action :set_sales_order_item

      def create
        respond_to do |format|
          if @sales_order_item.deliver!
            format.turbo_stream do
              flash[:notice] = t(".success")
            end
            format.html { redirect_to sales_sales_order_path(@sales_order), notice: t(".success") }
          else
            flash[:alert] = @sales_order_item.errors.full_messages.join(", ")
            format.turbo_stream
            format.html do
              redirect_to sales_sales_order_path(@sales_order),
                alert: @sales_order_item.errors.full_messages.join(", ")
            end
          end
        end
      end

      private

      def set_sales_order
        @sales_order = SalesOrder.find(params[:sales_order_id])
      end

      def set_sales_order_item
        @sales_order_item = @sales_order.sales_order_items.find(params[:id])
      end
    end
  end
end
