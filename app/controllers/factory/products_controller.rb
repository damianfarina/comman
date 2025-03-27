module Factory
  class ProductsController < ApplicationController
    include IdSearchQueryProcessor

    before_action :set_product, only: %i[ show edit update destroy ]

    # GET /products or /products.json
    def index
      @q = Product.manufactured_products.includes(:formula).ransack(params[:q])
      @q.sorts = default_sort if @q.sorts.empty?
      @products = @q.result.page(params[:page])
    end

    # GET /products/1 or /products/1.json
    def show
    end

    # GET /products/new
    def new
      @product = Product.new(productable: ManufacturedProduct.new)
      @product.supplier_products.build(supplier: Supplier.in_house)
    end

    # GET /products/1/edit
    def edit
    end

    # POST /products or /products.json
    def create
      @product = Product.new(productable: ManufacturedProduct.new)
      @product.supplier_products.build(supplier: Supplier.in_house)
      @product.assign_attributes(product_params)

      respond_to do |format|
        if @product.save(context: :factory)
          format.html { redirect_to factory_product_path(@product), notice: t(".success") }
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

      respond_to do |format|
        if @product.save(context: :factory)
          format.html { redirect_to factory_product_path(@product), notice: t(".success") }
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
        format.html { redirect_to factory_products_path, status: :see_other, notice: t(".success") }
        format.json { head :no_content }
      end
    end

    private
      def set_product
        @product = Product.find(params.expect(:id))
      end

      def product_params
        params.require(:product).permit(
          :comments,
          :current_stock,
          :max_stock,
          :min_stock,
          productable_attributes: [
            :formula_id,
            :id,
            :pressure,
            :shape,
            :size,
            :weight,
          ],
        )
      end

      def default_sort
        [ "id asc" ]
      end
  end
end
