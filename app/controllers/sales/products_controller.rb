module Sales
  class ProductsController < ApplicationController
    include IdSearchQueryProcessor

    before_action :set_product, only: %i[ show ]

    # GET /products or /products.json
    def index
      @q = Product.ransack(params[:q])
      @q.sorts = default_sort if @q.sorts.empty?
      @products = @q.result.page(params[:page])
    end

    # GET /products/1 or /products/1.json
    def show
    end

    private

    def set_product
      @product = Product.find(params.expect(:id))
    end

    def default_sort
      [ "id desc" ]
    end
  end
end
