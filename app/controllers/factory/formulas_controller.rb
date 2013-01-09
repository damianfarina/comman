class Factory::FormulasController < Factory::FactoryController
  layout "factory"

  # GET /formulas
  # GET /formulas.json
  def index
    @formulas = Formula.order(:name)
      .paginate(:page => params[:page])

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
    @formula.formula_items.build

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
end
