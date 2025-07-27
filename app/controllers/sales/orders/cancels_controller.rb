module Sales
  module Orders
    class CancelsController < ApplicationController
      before_action :set_sales_order
      before_action :set_sales_order_item

      def create
        respond_to do |format|
          if @sales_order.cancel_item!(@sales_order_item)
            flash[:notice] = t(".success")
            format.turbo_stream
            format.html { redirect_to sales_order_path(@sales_order) }
          else
            flash[:alert] = @sales_order.errors.full_messages.join(", ") + " " + @sales_order_item.errors.full_messages.join(", ")
            format.turbo_stream
            format.html do
              redirect_to sales_order_path(@sales_order)
            end
          end
        end
      end

      private

      def set_sales_order
        @sales_order = SalesOrder.find(params[:order_id])
      end

      def set_sales_order_item
        @sales_order_item = @sales_order.sales_order_items.find(params[:id])
      end
    end
  end
end
