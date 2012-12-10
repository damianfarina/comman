class Business::DeliveryNotesController < ApplicationController
  layout "business"
  
  # GET /delivery_notes
  # GET /delivery_notes.json
  def index
    @delivery_notes = DeliveryNote.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @delivery_notes }
    end
  end

  # GET /delivery_notes/1
  # GET /delivery_notes/1.json
  def show
    @delivery_note = DeliveryNote.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @delivery_note }
    end
  end

  # GET /delivery_notes/new
  # GET /delivery_notes/new.json
  def new
    @delivery_note = DeliveryNote.new
    @delivery_note.delivery_note_items.build(:product_id => 100)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @delivery_note }
    end
  end

  # GET /delivery_notes/1/edit
  def edit
    @delivery_note = DeliveryNote.find(params[:id])
  end

  # POST /delivery_notes
  # POST /delivery_notes.json
  def create
    @delivery_note = DeliveryNote.new(params[:delivery_note])

    respond_to do |format|
      if @delivery_note.save
        format.html { redirect_to business_delivery_note_path(@delivery_note), notice: 'Delivery note was successfully created.' }
        format.json { render json: @delivery_note, status: :created, location: @delivery_note }
      else
        format.html { render action: "new" }
        format.json { render json: @delivery_note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /delivery_notes/1
  # PUT /delivery_notes/1.json
  def update
    @delivery_note = DeliveryNote.find(params[:id])

    respond_to do |format|
      if @delivery_note.update_attributes(params[:delivery_note])
        format.html { redirect_to business_delivery_note_path(@delivery_note), notice: 'Delivery note was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @delivery_note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /delivery_notes/1
  # DELETE /delivery_notes/1.json
  def destroy
    @delivery_note = DeliveryNote.find(params[:id])
    @delivery_note.destroy

    respond_to do |format|
      format.html { redirect_to business_delivery_notes_path }
      format.json { head :no_content }
    end
  end

  def delivery_note_item
    @delivery_note_item = DeliveryNoteItem.new :product_id => params[:product_id]
    
    respond_to do |format|
      format.html { render :partial => 'delivery_note_item', :locals => { :item => @delivery_note_item } }
      format.json { render :json => @product }
      format.js
    end
  end
end
