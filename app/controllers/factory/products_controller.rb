class Factory::ProductsController < Factory::FactoryController
  layout "factory"

  # GET /products
  # GET /products.json
  def index
    @search = Product.search(params[:q])
    @products = @search.result.paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @products }
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @product }
    end
  end

  # GET /products/new
  # GET /products/new.json
  def new
    @product = Product.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @product }
    end
  end

  # GET /products/1/edit
  def edit
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        format.html { redirect_to factory_product_path(@product), :flash => { :success => t('controllers.successfully_created') } }
        format.json { render :json =>@product, :status =>:created, :location => @product }
      else
        format.html { render :action => "new" }
        format.json { render :json => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to factory_product_path(@product), :flash => { :success => t('controllers.successfully_updated') } }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @product.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.html { redirect_to factory_products_path, :flash => { :success => t('controllers.successfully_destroyed') } }
      format.json { head :no_content }
    end
  end

  def autocomplete
    @products = Product.name_or_id_contains(params['term']).with_formula(params['formula_id']).select("id, name, formula_id").limit(10)
    render :json => @products.map{|item| {:id => item.id, :value => item.name, :formula_id => item.formula_id} }
  end
end
