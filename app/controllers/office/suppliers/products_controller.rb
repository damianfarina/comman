module Office
  module Suppliers
    class ProductsController < ApplicationController
      include IdSearchQueryProcessor

      before_action :set_supplier

      # GET /office/suppliers/:supplier_id/products or /office/suppliers/:supplier_id/products.json
      def index
        @q = @supplier.supplied_products.ransack(params[:q])
        @q.sorts = default_sort if @q.sorts.empty?
        @supplied_products = @q.result.page(params[:page])
      end

      private

      def set_supplier
        @supplier = Supplier.find(params[:supplier_id])
      end

      def default_sort
        [ "name asc" ]
      end
    end
  end
end
