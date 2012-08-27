class Factory::MakingOrdersController < Factory::FactoryController
  layout "factory"

  # GET /making_orders
  # GET /making_orders.json
  def index
    @making_orders = MakingOrder.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @making_orders }
    end
  end

  # GET /making_orders/1
  # GET /making_orders/1.json
  def show
    @making_order = MakingOrder.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render :json => @making_order }
      format.pdf  { render :pdf  => "Orden_de_fabricacion_##{@making_order.id}" }
    end
  end

  # GET /making_orders/new
  # GET /making_orders/new.json
  def new
    @making_order = MakingOrder.new
    @making_order.making_order_items.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @making_order }
    end
  end

  # GET /making_orders/1/edit
  def edit
    @making_order = MakingOrder.find(params[:id])
  end

  # POST /making_orders
  # POST /making_orders.json
  def create
    @making_order = MakingOrder.new(params[:making_order])

    respond_to do |format|
      if @making_order.save
        format.html { redirect_to factory_making_order_path(@making_order), :flash => { :success => t('controllers.successfully_created') } }
        format.json { render :json => @making_order, :status => :created, :location => @making_order }
      else
        format.html { render :action => "new" }
        format.json { render :json => @making_order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /making_orders/1
  # PUT /making_orders/1.json
  def update
    @making_order = MakingOrder.find(params[:id])

    respond_to do |format|
      if @making_order.update_attributes(params[:making_order])
        format.html { redirect_to factory_making_order_path(@making_order), :flash => { :success => t('controllers.successfully_updated') } }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @making_order.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /making_orders/1
  # DELETE /making_orders/1.json
  def destroy
    @making_order = MakingOrder.find(params[:id])
    @making_order.destroy

    respond_to do |format|
      format.html { redirect_to factory_making_orders_path, :flash => { :success => t('controllers.successfully_destroyed') } }
      format.json { head :no_content }
    end
  end
end
