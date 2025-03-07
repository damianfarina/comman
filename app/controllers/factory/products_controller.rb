module Factory
  class ProductsController < ApplicationController
    include IdSearchQueryProcessor

    before_action :set_product, only: %i[ show edit update destroy ]

    # GET /products or /products.json
    def index
      @q = Product.includes(:formula).ransack(params[:q] || default_sort)
      @products = @q.result.page(params[:page])
    end

    # GET /products/1 or /products/1.json
    def show
    end

    # GET /products/new
    def new
      @product = Product.new
    end

    # GET /products/1/edit
    def edit
    end

    # POST /products or /products.json
    def create
      @product = Product.new(product_params)

      respond_to do |format|
        if @product.save
          format.html { redirect_to factory_product_path(@product), notice: "Product was successfully created." }
          format.json { render :show, status: :created, location: @product }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /products/1 or /products/1.json
    def update
      respond_to do |format|
        if @product.update(product_params)
          format.html { redirect_to factory_product_path(@product), notice: "Product was successfully updated." }
          format.json { render :show, status: :ok, location: @product }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /products/1 or /products/1.json
    def destroy
      @product.destroy!

      respond_to do |format|
        format.html { redirect_to factory_products_path, status: :see_other, notice: "Product was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    private
      def set_product
        @product = Product.find(params.expect(:id))
      end

      def product_params
        params.expect(product: [ :name, :price, :formula_id, :shape, :size, :weight, :pressure ])
      end

      def default_sort
        { s: "id asc" }
      end
  end
end
