class Factory::FormulaElementsController < Factory::FactoryController
  layout "factory"

  # GET /formula_elements
  # GET /formula_elements.json
  def index
    @formula_elements = FormulaElement.missing_first.paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @formula_elements }
    end
  end

  # GET /formula_elements/1
  # GET /formula_elements/1.json
  def show
    @formula_element = FormulaElement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @formula_element }
    end
  end

  # GET /formula_elements/new
  # GET /formula_elements/new.json
  def new
    @formula_element = FormulaElement.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @formula_element }
    end
  end

  # GET /formula_elements/1/edit
  def edit
    @formula_element = FormulaElement.find(params[:id])
  end

  # POST /formula_elements
  # POST /formula_elements.json
  def create
    @formula_element = FormulaElement.new(params[:formula_element])

    respond_to do |format|
      if @formula_element.save
        format.html { redirect_to factory_formula_element_path(@formula_element), :notice => 'Formula element was successfully created.' }
        format.json { render :json => @formula_element, :status => :created, :location => @formula_element }
      else
        format.html { render :action => "new" }
        format.json { render :json => @formula_element.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /formula_elements/1
  # PUT /formula_elements/1.json
  def update
    @formula_element = FormulaElement.find(params[:id])

    respond_to do |format|
      if @formula_element.update_attributes(params[:formula_element])
        format.html { redirect_to factory_formula_element_path(@formula_element), :notice => 'Formula element was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @formula_element.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /formula_elements/1
  # DELETE /formula_elements/1.json
  def destroy
    @formula_element = FormulaElement.find(params[:id])

    respond_to do |format|
      if @formula_element.destroy
        format.html { redirect_to factory_formula_elements_url }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @formula_element.errors, :status => :unprocessable_entity }
      end
    end
  end

  def preview_join
    @formula_elements = FormulaElement.where(:id => params[:formula_element_ids].split(','))
    @formula_element = @formula_elements.first
    respond_to do |format|
      format.html
    end
  end

  def join
    @formula_elements = FormulaElement.where(:id => params[:formula_element_ids])
    @formula_element = @formula_elements.first
    @formula_element.update_attributes params[:formula_element]
    if @formula_element.join_with(@formula_elements - [@formula_element])
      respond_to do |format|
        format.html { redirect_to factory_formula_elements_path, :flash => { :success => 'Unidos correctamente'} }
      end
    else
      respond_to do |format|
        format.html render :preview_join
      end
    end
  end

  def autocomplete
    @elements = FormulaElement.name_or_id_contains(params['term']).select("id, name").limit(10)
    respond_to do |format|
      format.json { render :json => @elements.map { |item| {:id => item.id, :value => item.name} } }
    end
  end
end
