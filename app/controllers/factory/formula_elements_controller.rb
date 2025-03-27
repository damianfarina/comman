module Factory
  class FormulaElementsController < ApplicationController
    include IdSearchQueryProcessor

    before_action :set_formula_element, only: %i[ show edit update destroy ]

    # GET /formula_elements or /formula_elements.json
    def index
      @q = FormulaElement.ransack(params[:q])
      @q.sorts = default_sort if @q.sorts.empty?
      @formula_elements = @q.result.page(params[:page])
    end

    # GET /formula_elements/1 or /formula_elements/1.json
    def show
    end

    # GET /formula_elements/new
    def new
      @formula_element = FormulaElement.new
    end

    # GET /formula_elements/1/edit
    def edit
    end

    # POST /formula_elements or /formula_elements.json
    def create
      @formula_element = FormulaElement.new(formula_element_params)

      respond_to do |format|
        if @formula_element.save
          format.html { redirect_to factory_formula_element_path(@formula_element), notice: "La materia prima fue creada." }
          format.json { render :show, status: :created, location: @formula_element }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @formula_element.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /formula_elements/1 or /formula_elements/1.json
    def update
      respond_to do |format|
        if @formula_element.update(formula_element_params)
          format.html { redirect_to factory_formula_element_path(@formula_element), notice: "La materia prima fue actualizada." }
          format.json { render :show, status: :ok, location: @formula_element }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @formula_element.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /formula_elements/1 or /formula_elements/1.json
    def destroy
      raise "Formula elements cannot be destroyed! They are part of the production history. Implement archiving instead."
      @formula_element.destroy!

      respond_to do |format|
        format.html { redirect_to factory_formula_elements_path, status: :see_other, notice: "La materia prima fue archivada." }
        format.json { head :no_content }
      end
    end

    private

      def default_sort
        [ "name asc" ]
      end

      # Use callbacks to share common setup or constraints between actions.
      def set_formula_element
        @formula_element = FormulaElement.find(params[:id])
      end

      def formula_element_params
        params.expect(
          formula_element: [
            :name,
            :min_stock,
            :current_stock,
            :infinite,
          ],
        )
      end
  end
end
