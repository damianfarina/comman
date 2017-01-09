class Factory::ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @search = Product.search(params[:q])
    @products = @search.result.page(params[:page]).order(:id)
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to factory_product_path(@product), notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: factory_product_path(@product) }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to factory_product_path(@product), notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: factory_product_path(@product) }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to factory_products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def autocomplete
    @products = Product.name_or_id_contains(params['term']).with_formula(params['formula_id']).select("id, name, formula_id").limit(10)
    render :json => @products.map{|item| {:id => item.id, :value => item.name, :formula_id => item.formula_id} }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:formula_id, :shape, :size, :weight, :pressure, :price)
    end
end
