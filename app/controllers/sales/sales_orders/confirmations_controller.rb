module Sales
  module SalesOrders
    class ConfirmationsController < ApplicationController
      before_action :set_sales_order

      def create
        if @sales_order.confirm!
          redirect_to sales_sales_order_path(@sales_order), notice: t(".success")
        else
          redirect_to sales_sales_order_path(@sales_order), alert: @sales_order.errors.full_messages.join(", ")
        end
      end

      private

      def set_sales_order
        @sales_order = SalesOrder.find(params[:id])
      end
    end
  end
end
