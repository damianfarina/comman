module Sales
  module Orders
    module Items
      class CompletesController < ApplicationController
        before_action :set_order
        before_action :set_item

        def create
          respond_to do |format|
            if @item.complete!
              format.turbo_stream do
                flash[:notice] = t(".success")
              end
              format.html { redirect_to sales_order_path(@order), notice: t(".success") }
            else
              flash[:alert] = @item.errors.full_messages.join(", ")
              format.turbo_stream
              format.html do
                redirect_to sales_order_path(@order),
                  alert: @item.errors.full_messages.join(", ")
              end
            end
          end
        end

        private

        def set_order
          @order = Sales::Order.find(params[:order_id])
        end

        def set_item
          @item = @order.items.find(params[:id])
        end
      end
    end
  end
end
