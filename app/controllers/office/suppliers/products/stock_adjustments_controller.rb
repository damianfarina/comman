module Office
  module Suppliers
    module Products
      class StockAdjustmentsController < ApplicationController
        before_action :set_supplier
        before_action :set_product

        def create
          @product.increase_stock = stock_delta

          respond_to do |format|
            if @product.save
              flash.now[:notice] = t(".success")
              format.turbo_stream
              format.html { redirect_to office_supplier_path(@supplier), notice: t(".success") }
            else
              @product.reload
              flash.now[:alert] = @product.errors.full_messages.join(", ")
              format.turbo_stream
              format.html { redirect_to office_supplier_path(@supplier), alert: @product.errors.full_messages.join(", ") }
            end
          end
        end

        def destroy
          @product.decrease_stock = stock_delta

          respond_to do |format|
            if @product.save
              flash.now[:notice] = t(".success")
              format.turbo_stream
              format.html { redirect_to office_supplier_path(@supplier), notice: t(".success") }
            else
              @product.reload
              flash.now[:alert] = @product.errors.full_messages.join(", ")
              format.turbo_stream
              format.html { redirect_to office_supplier_path(@supplier), alert: @product.errors.full_messages.join(", ") }
            end
          end
        end

        private

        def set_supplier
          @supplier = Supplier.find(params.expect(:supplier_id))
        end

        def set_product
          @product = @supplier.supplied_products.find(params.expect(:product_id))
        end

        def stock_delta
          params.dig(:product, :stock_delta)
        end
      end
    end
  end
end
