class Factory::FormulaElementsController < ApplicationController
  before_action :set_formula_element, only: [:show, :edit, :update, :destroy]

  def index
    @search = FormulaElement.search(params[:q])
    @formula_elements = @search.result.page(params[:page]).order(:id)
  end

  def show
  end

  def new
    @formula_element = FormulaElement.new
  end

  def edit
  end

  def create
    @formula_element = FormulaElement.new(formula_element_params)

    respond_to do |format|
      if @formula_element.save
        format.html { redirect_to factory_formula_element_path(@formula_element), notice: 'FormulaElement was successfully created.' }
        format.json { render :show, status: :created, location: factory_formula_element_path(@formula_element) }
      else
        format.html { render :new }
        format.json { render json: @formula_element.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @formula_element.update(formula_element_params)
        format.html { redirect_to factory_formula_element_path(@formula_element), notice: 'FormulaElement was successfully updated.' }
        format.json { render :show, status: :ok, location: factory_formula_element_path(@formula_element) }
      else
        format.html { render :edit }
        format.json { render json: @formula_element.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @formula_element.destroy
    respond_to do |format|
      format.html { redirect_to factory_formula_elements_url, notice: 'FormulaElement was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def autocomplete
    @formula_elements = FormulaElement.name_or_id_contains(params['term']).with_formula(params['formula_id']).select("id, name, formula_id").limit(10)
    render :json => @formula_elements.map{|item| {:id => item.id, :value => item.name, :formula_id => item.formula_id} }
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_formula_element
      @formula_element = FormulaElement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def formula_element_params
      params.require(:formula_element).permit(:name, :min_stock, :current_stock, :infinite)
    end
end
