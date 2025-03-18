module Factory
  class ProductsController < ApplicationController
    include IdSearchQueryProcessor

    before_action :set_product, only: %i[ show edit update destroy ]

    # GET /products or /products.json
    def index
      @q = Product.manufactured_products.includes(:formula).ransack(params[:q] || default_sort)
      @products = @q.result.page(params[:page])
    end

    # GET /products/1 or /products/1.json
    def show
    end

    # GET /products/new
    def new
      @product = Product.new(productable: ManufacturedProduct.new)
    end

    # GET /products/1/edit
    def edit
    end

    # POST /products or /products.json
    def create
      @product = Product.new(
        **product_params,
        productable: ManufacturedProduct.new(manufactured_product_params),
      )

      respond_to do |format|
        if @product.save(context: :factory)
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
      @product.assign_attributes(product_params)
      @product.productable.assign_attributes(manufactured_product_params)

      respond_to do |format|
        if @product.save(context: :factory)
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
        params.expect(product: [
          :current_stock,
          :description,
          :max_stock,
          :min_stock,
        ])
      end

      def manufactured_product_params
        params
          .require(:product)
          .expect(productable_attributes: [
            :formula_id,
            :pressure,
            :shape,
            :size,
            :weight,
          ])
      end

      def default_sort
        { s: "id asc" }
      end
  end
end
