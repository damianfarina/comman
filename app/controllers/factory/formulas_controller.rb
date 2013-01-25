class Factory::FormulasController < Factory::FactoryController
  layout "factory"

  # GET /formulas
  # GET /formulas.json
  def index
    @search = Formula.search(params[:q])
    @formulas = @search.result.paginate(:page => params[:page])

    # @search = Formula.order(:name).search(params[:search])
    # @formulas = @search.result.paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @formulas }
    end
  end

  # GET /formulas/1
  # GET /formulas/1.json
  def show
    @formula = Formula.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @formula }
    end
  end

  # GET /formulas/new
  # GET /formulas/new.json
  def new
    @formula = Formula.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @formula }
    end
  end

  # GET /formulas/1/edit
  def edit
    @formula = Formula.find(params[:id])
  end

  # POST /formulas
  # POST /formulas.json
  def create
    @formula = Formula.new(params[:formula])

  respond_to do |format|
      if @formula.save
        format.html { redirect_to factory_formula_path(@formula), :flash => { :success => t('controllers.successfully_created') } }
        format.json { render :json => @formula, :status => :created, :location => @formula }
      else
        format.html { render :action => "new" }
        format.json { render :json => @formula.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /formulas/1
  # PUT /formulas/1.json
  def update
    @formula = Formula.find(params[:id])

    respond_to do |format|
      if @formula.update_attributes(params[:formula])
        format.html { redirect_to factory_formula_path(@formula), :flash => { :success => t('controllers.successfully_updated') } }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @formula.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /formulas/1
  # DELETE /formulas/1.json
  def destroy
    @formula = Formula.find(params[:id])
    @formula.destroy

    respond_to do |format|
      format.html { redirect_to factory_formulas_path, :flash => { :success => t('controllers.successfully_destroyed') } }
      format.json { head :no_content }
    end
  end

  def formula_item
    @formula_item = FormulaItem.new :formula_element_id => params[:formula_element_id]
    
    respond_to do |format|
      format.html { render :partial => 'formula_item', :locals => { :item => @formula_item } }
      format.json { render :json => @formula_item }
      format.js
    end
  end
end
