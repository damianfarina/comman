module Sales
  class OrdersController < ApplicationController
    include IdSearchQueryProcessor

    before_action :set_order, only: %i[ show edit update destroy ]
    before_action :check_editable_status, only: %i[ edit update ]
    before_action :check_workable_status, only: %i[ show ]

    # GET /orders or /orders.json
    def index
      @q = Sales::Order.ransack(params[:q])
      @q.sorts = default_sort if @q.sorts.empty?
      @orders = @q.result
        .includes(:products, :client, :items)
        .page(params[:page])
    end

    # GET /orders/1 or /orders/1.json
    def show
    end

    # GET /orders/new
    def new
      @order = Sales::Order.new(client_id: client_id_from_params)
      @order.items.build
    end

    # GET /orders/1/edit
    def edit
    end

    # POST /orders or /orders.json
    def create
      @order = Sales::Order.new(order_params)

      respond_to do |format|
        if @order.save && confirm_if_requested
          format.html { redirect_to @order, notice: t(".success") }
          format.json { render :show, status: :created, location: @order }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @order.errors, status: :unprocessable_entity }
        end
      end
    end

    def preview_totals
      @order = Sales::Order.new(order_params)

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "order_totals_preview",
            partial: "sales/orders/order_totals",
            locals: { order: @order }
          )
        end
        format.html { render :preview, status: :ok }
        format.json { render :preview, status: :ok, location: @order }
      end
    end

    # PATCH/PUT /orders/1 or /orders/1.json
    def update
      respond_to do |format|
        if @order.update(order_params) && confirm_if_requested
          format.html { redirect_to [ :edit, @order ], notice: t(".success") }
          format.json { render :show, status: :ok, location: @order }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @order.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /orders/1 or /orders/1.json
    def destroy
      respond_to do |format|
        if @order.cancel!
          format.html { redirect_to @order, notice: t(".success") }
          format.json { head :no_content }
        else
          flash[:alert] = @order.errors.full_messages.join(", ")
          format.html { redirect_to @order }
          format.json { render json: @order.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def confirm_if_requested
      return true unless confirm_param?

      @order.confirm!
    end

    def check_workable_status
      unless @order.workable?
        redirect_to edit_sales_order_path(@order)
      end
    end

    def check_editable_status
      unless @order.editable?
        redirect_to sales_order_path(@order)
      end
    end

    def set_order
      @order = Sales::Order.find(params.expect(:id))
    end

    def order_params
      params.require(:sales_order).permit(
        :client_id,
        :comments,
        items_attributes: [
          :_destroy,
          :id,
          :product_id,
          :quantity,
        ]
      )
    end

    def default_sort
      [ "status_changed_at_order desc" ]
    end

    def client_id_from_params
      if params[:client_id].present?
        params[:client_id]
      elsif params[:sales_order].present? && params[:sales_order][:client_id].present?
        params[:sales_order][:client_id]
      else
        redirect_to sales_orders_path, alert: "Client ID is required to create a sales order."
      end
    end

    def confirm_param?
      params[:commit] == "confirm"
    end
  end
end
