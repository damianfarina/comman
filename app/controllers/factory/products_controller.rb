class Factory::ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    q = params[:q] || { :s => "name asc" }
    @search = Product.search(q)
    @products = @search.result.page(params[:page]).order(:id)
  end

  def show; end

  def new
    @product = Product.new
  end

  def edit; end

  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html do
          redirect_to factory_product_path(@product),
            notice: t('controllers.successfully_created')
        end
        format.json do
          render :show,
            status: :created,
            location: factory_product_path(@product)
        end
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html do
          redirect_to factory_product_path(@product),
            notice: t('controllers.successfully_updated')
        end
        format.json { render :show, status: :ok, location: factory_product_path(@product) }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product.destroy
    respond_to do |format|
      format.html do
        redirect_to factory_products_url, notice: t('controllers.successfully_destroyed')
      end
      format.json { head :no_content }
    end
  end

  def autocomplete
    @products = Product
      .name_or_id_contains(params['term'])
      .with_formula(params['formula_id'])
      .select("id, name, formula_id")
      .limit(10)

    render json: @products
      .map { |item| {id: item.id, value: item.name, formula_id: item.formula_id} }
  end

private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:formula_id, :shape, :size, :weight, :pressure, :price)
  end
end
