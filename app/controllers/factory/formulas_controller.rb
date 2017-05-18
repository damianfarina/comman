class Factory::FormulasController < ApplicationController
  before_action :set_formula, only: [:show, :edit, :update, :destroy]

  def index
    q = params[:q] || { :s => "name asc" }
    @search = Formula.search(q)
    @formulas = @search.result.page(params[:page]).order(:id)
  end

  def show; end

  def new
    @formula = Formula.new
    @formula.formula_items.build
  end

  def edit; end

  def create
    @formula = Formula.new(formula_params)

    respond_to do |format|
      if @formula.save
        format.html do
          redirect_to factory_formula_path(@formula),
            notice: t('controllers.successfully_created')
        end
        format.json { render :show, status: :created, location: @formula }
      else
        format.html { render :new }
        format.json { render json: @formula.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @formula.update(formula_params)
        format.html do
          redirect_to factory_formula_path(@formula),
            notice: t('controllers.successfully_updated')
        end
        format.json { render :show, status: :ok, location: @formula }
      else
        format.html { render :edit }
        format.json { render json: @formula.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @formula.destroy
    respond_to do |format|
      format.html do
        redirect_to factory_formulas_url,
          notice: t('controllers.successfully_destroyed')
      end
      format.json { head :no_content }
    end
  end

private

  def set_formula
    @formula = Formula.includes(formula_items: [:formula_element]).find(params[:id])
  end

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
        :proportion,
        :_destroy
      ])
  end
end
