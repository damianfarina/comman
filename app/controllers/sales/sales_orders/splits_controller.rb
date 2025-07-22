module Sales
  module SalesOrders
    class SplitsController < ApplicationController
      before_action :set_sales_order, only: %i[ new create ]
      before_action :set_sales_order_item, only: %i[ new create ]

      def new
      end

      def create
        quantity = split_params[:quantity].to_i
        @new_sales_order_item = @sales_order_item.split!(quantity)

        respond_to do |format|
          if @new_sales_order_item.valid? && @new_sales_order_item.errors.empty? && @sales_order_item.errors.empty?
            flash[:notice] = t(".success")
            format.turbo_stream
            format.html { redirect_to sales_sales_order_path(@sales_order) }
            format.json { head :created }
          else
            flash[:alert] = @sales_order_item.errors.full_messages.join(", ")
            format.turbo_stream
            format.html { render :new, status: :unprocessable_entity }
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
        @sales_order_item = @sales_order.sales_order_items.find(params[:id])
      end
    end
  end
end
