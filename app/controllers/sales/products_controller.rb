module Sales
  class ProductsController < ApplicationController
    before_action :set_product, only: %i[ show ]

    # GET /products/1 or /products/1.json
    def show
    end

    private

    def set_product
      @product = Product.find(params.expect(:id))
    end
  end
end
