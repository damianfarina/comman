module Sales
  module Orders
    class FulfillController < ApplicationController
      before_action :set_order

      def create
        respond_to do |format|
          if @order.fulfill!
            flash[:notice] = t(".success")
            format.turbo_stream
            format.html { redirect_to sales_order_path(@order) }
          else
            flash[:alert] = @order.errors.full_messages.join(", ")
            format.turbo_stream
            format.html do
              redirect_to sales_order_path(@order)
            end
          end
        end
      end

      private

      def set_order
        @order = Sales::Order.find(params[:id])
      end
    end
  end
end
