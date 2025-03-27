module Factory
  class FormulasController < ApplicationController
    include IdSearchQueryProcessor

    before_action :set_formula, only: %i[ show edit update destroy ]
    before_action :set_formula_elements, only: %i[ new create edit update destroy ]

    # GET /formulas or /formulas.json
    def index
      @q = Formula.ransack(params[:q])
      @q.sorts = default_sort if @q.sorts.empty?
      @formulas = @q.result.page(params[:page])
    end

    # GET /formulas/1 or /formulas/1.json
    def show
      @pie_chart_data = @formula
        .formula_items
        .includes(:formula_element)
        .map do |item|
          proportion = item.proportion.round(2)
          {
            name: "#{item.formula_element.name} (#{proportion}%)",
            proportion: proportion,
          }
        end
    end

    # GET /formulas/new
    def new
      @formula = Formula.new
      @formula.formula_items.build
    end

    # GET /formulas/1/edit
    def edit
    end

    # POST /formulas or /formulas.json
    def create
      @formula = Formula.new(formula_params)

      respond_to do |format|
        if @formula.save
          format.html { redirect_to factory_formula_path(@formula), notice: "La fórmula fue creada." }
          format.json { render :show, status: :created, location: factory_formula_url(@formula) }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @formula.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /formulas/1 or /formulas/1.json
    def update
      respond_to do |format|
        if @formula.update(formula_params)
          format.html { redirect_to factory_formula_path(@formula), notice: "La fórmula fue actualizada." }
          format.json { render :show, status: :ok, location: factory_formula_url(@formula) }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @formula.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /formulas/1 or /formulas/1.json
    def destroy
      @formula.destroy!

      respond_to do |format|
        format.html { redirect_to factory_formulas_path, status: :see_other, notice: "La fórmula fue eliminada." }
        format.json { head :no_content }
      end
    end

    private

      def default_sort
        [ "name asc" ]
      end

      def set_formula
        @formula = Formula.find(params[:id])
      end

      def set_formula_elements
        @formula_elements = FormulaElement.order(:name)
      end

      def formula_params
        params.expect(
          formula: [
            :abrasive,
            :grain,
            :hardness,
            :porosity,
            :alloy,
            formula_items_attributes: [
              [
                :id,
                :formula_element_id,
                :proportion,
                :_destroy,
              ],
            ],
          ],
        )
      end
  end
end
