class Factory::FormulasController < ApplicationController
  before_action :set_formula, only: [:show, :edit, :update, :destroy]

  # GET /factory/formulas
  # GET /factory/formulas.json
  def index
    @search = Formula.search(params[:q])
    @formulas = @search.result.page(params[:page]).order(:id)
  end

  # GET /factory/formulas/1
  # GET /factory/formulas/1.json
  def show
  end

  # GET /factory/formulas/new
  def new
    @formula = Formula.new
    @formula.formula_items.build
  end

  # GET /factory/formulas/1/edit
  def edit
    @formula.formula_items.build
  end

  # POST /factory/formulas
  # POST /factory/formulas.json
  def create
    @formula = Formula.new(formula_params)

    respond_to do |format|
      if @formula.save
        format.html { redirect_to factory_formula_path(@formula), notice: 'Formula was successfully created.' }
        format.json { render :show, status: :created, location: @formula }
      else
        format.html { render :new }
        format.json { render json: @formula.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /factory/formulas/1
  # PATCH/PUT /factory/formulas/1.json
  def update
    respond_to do |format|
      if @formula.update(formula_params)
        format.html { redirect_to factory_formula_path(@formula), notice: 'Formula was successfully updated.' }
        format.json { render :show, status: :ok, location: @formula }
      else
        format.html { render :edit }
        format.json { render json: @formula.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /factory/formulas/1
  # DELETE /factory/formulas/1.json
  def destroy
    @formula.destroy
    respond_to do |format|
      format.html { redirect_to factory_formulas_url, notice: 'Formula was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_formula
      @formula = Formula.includes(formula_items: [:formula_element]).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def formula_params
      params.require(:formula).permit(
        :name,
        :abrasive,
        :grain,
        :hardness,
        :porosity,
        :alloy,
        formula_items_attributes: [
          :id,
          :formula_element_id,
          :proportion
        ])
    end
end
