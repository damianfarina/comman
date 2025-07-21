module Sales
  module SalesOrders
    class SplitsController < ApplicationController
      before_action :set_sales_order, only: %i[ new create ]
      before_action :set_sales_order_item, only: %i[ new create ]

      def new
      end

      def create
        quantity = split_params[:quantity].to_i
        @new_sales_order_item = @sales_order_item.split(quantity)

        respond_to do |format|
          if @new_sales_order_item.valid? && @sales_order_item.errors.empty?
            format.html { redirect_to sales_sales_order_path(@sales_order), notice: t(".success") }
            format.turbo_stream
            format.json { head :created }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.turbo_stream { render :new, status: :unprocessable_entity }
            format.json { render json: @sales_order_item.errors, status: :unprocessable_entity }
          end
        end
      end

      private

      def split_params
        params.require(:sales_order_item).permit(:quantity)
      end

      def set_sales_order
        @sales_order = SalesOrder.find_by_id!(params[:sales_order_id])
      end

      def set_sales_order_item
        @sales_order_item = @sales_order.sales_order_items.find(params[:sales_order_item_id])
      end
    end
  end
end
