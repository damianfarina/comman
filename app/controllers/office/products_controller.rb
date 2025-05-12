module Office
  class ProductsController < ApplicationController
    include IdSearchQueryProcessor

    before_action :set_product, only: %i[ show edit update destroy ]

    # GET /products or /products.json
    def index
      @q = Product.ransack(params[:q])
      @q.sorts = default_sort if @q.sorts.empty?
      @products = @q.result
        .includes(:suppliers, :supplier)
        .page(params[:page])
    end

    # GET /products/1 or /products/1.json
    def show
    end

    # GET /products/new
    def new
      @product = Product.new(productable: PurchasedProduct.new)
      @product.supplied_by.build
    end

    # GET /products/1/edit
    def edit
      @product.supplied_by.build
    end

    # POST /products or /products.json
    def create
      @product = Product.new(
        **product_params,
        productable: PurchasedProduct.new,
      )

      respond_to do |format|
        if @product.save(context: :office)
          format.html { redirect_to office_product_path(@product), notice: t(".success") }
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
        if @product.save(context: :office)
          format.html { redirect_to office_product_path(@product), notice: t(".success") }
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
        format.html { redirect_to office_products_path, status: :see_other, notice: t(".success") }
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
          :cover,
          :current_stock,
          :max_stock,
          :min_stock,
          :name,
          :price,
          :supplier_id,
          supplied_by_attributes: [
            :id,
            :code,
            :price,
            :supplier_id,
            :_destroy,
          ],
        )
      end

      def default_sort
        [ "id desc" ]
      end
  end
end
