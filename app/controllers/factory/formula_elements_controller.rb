class Factory::FormulaElementsController < ApplicationController
  before_action :set_formula_element, only: [:show, :edit, :update, :destroy]

  def index
    q = params[:q] || { :s => "name asc" }
    @search = FormulaElement.search(q)
    @formula_elements = @search.result.page(params[:page])
  end

  def show; end

  def new
    @formula_element = FormulaElement.new
  end

  def edit; end

  def create
    @formula_element = FormulaElement.new(formula_element_params)

    respond_to do |format|
      if @formula_element.save
        format.html do
          redirect_to factory_formula_element_path(@formula_element),
            notice: t('controllers.successfully_created')
        end
        format.json do
          render :show,
            status: :created,
            location: factory_formula_element_path(@formula_element)
        end
      else
        format.html { render :new }
        format.json { render json: @formula_element.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @formula_element.update(formula_element_params)
        format.html do
          redirect_to factory_formula_element_path(@formula_element),
            notice: t('controllers.successfully_updated')
        end
        format.json do
          render :show,
            status: :ok,
            location: factory_formula_element_path(@formula_element)
        end
      else
        format.html { render :edit }
        format.json { render json: @formula_element.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @formula_element.destroy
    respond_to do |format|
      format.html do
        redirect_to factory_formula_elements_url,
          notice: t('controllers.successfully_destroyed')
      end
      format.json { head :no_content }
    end
  end

  def autocomplete
    @formula_elements = FormulaElement
      .name_or_id_contains(params['term'])
      .select("id, name")
      .limit(10)

    render json: @formula_elements
      .map { |item| {id: item.id, value: item.name} }
  end

private

  def set_formula_element
    @formula_element = FormulaElement.find(params[:id])
  end

  def formula_element_params
    params.require(:formula_element).permit(:name, :min_stock, :current_stock, :infinite)
  end
end
