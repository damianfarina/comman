module Sales
  module Orders
    class FulfillController < ApplicationController
      before_action :set_sales_order

      def create
        respond_to do |format|
          if @sales_order.fulfill!
            flash[:notice] = t(".success")
            format.turbo_stream
            format.html { redirect_to sales_sales_order_path(@sales_order) }
          else
            flash[:alert] = @sales_order.errors.full_messages.join(", ")
            format.turbo_stream
            format.html do
              redirect_to sales_sales_order_path(@sales_order)
            end
          end
        end
      end

      private

      def set_sales_order
        @sales_order = SalesOrder.find(params[:id])
      end
    end
  end
end
