module Sales
  module Orders
    module Items
      class SplitsController < ApplicationController
        before_action :set_order, only: %i[ new create ]
        before_action :set_item, only: %i[ new create ]

        def new
        end

        def create
          quantity = split_params[:quantity].to_i
          @new_item = @item.split!(quantity)

          respond_to do |format|
            if @new_item.valid? && @new_item.errors.empty? && @item.errors.empty?
              flash[:notice] = t(".success")
              format.turbo_stream
              format.html { redirect_to sales_order_path(@order) }
              format.json { head :created }
            else
              flash[:alert] = @item.errors.full_messages.join(", ")
              format.turbo_stream
              format.html { render :new, status: :unprocessable_content }
              format.json { render json: @item.errors, status: :unprocessable_content }
            end
          end
        end

        private

        def split_params
          params.require(:sales_order_item).permit(:quantity)
        end

        def set_order
          @order = Sales::Order.find_by_id!(params[:order_id])
        end

        def set_item
          @item = @order.items.find(params[:id])
        end
      end
    end
  end
end
