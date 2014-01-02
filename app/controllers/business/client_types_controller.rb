class Business::ClientTypesController < ApplicationController
  layout "business"
  
  # GET /client_types
  # GET /client_types.json
  def index
    @client_types = ClientType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @client_types }
    end
  end

  # GET /client_types/1
  # GET /client_types/1.json
  def show
    @client_type = ClientType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @client_type }
    end
  end

  # GET /client_types/new
  # GET /client_types/new.json
  def new
    @client_type = ClientType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @client_type }
    end
  end

  # GET /client_types/1/edit
  def edit
    @client_type = ClientType.find(params[:id])
  end

  # POST /client_types
  # POST /client_types.json
  def create
    @client_type = ClientType.new(params[:client_type])

    respond_to do |format|
      if @client_type.save
        format.html { redirect_to business_client_type_path(@client_type), notice: 'Client type was successfully created.' }
        format.json { render json: @client_type, status: :created, location: @client_type }
      else
        format.html { render action: "new" }
        format.json { render json: @client_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /client_types/1
  # PUT /client_types/1.json
  def update
    @client_type = ClientType.find(params[:id])

    respond_to do |format|
      if @client_type.update_attributes(params[:client_type])
        format.html { redirect_to business_client_type_path(@client_type), notice: 'Client type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @client_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /client_types/1
  # DELETE /client_types/1.json
  def destroy
    @client_type = ClientType.find(params[:id])
    @client_type.destroy

    respond_to do |format|
      format.html { redirect_to business_client_types_url }
      format.json { head :no_content }
    end
  end
end
