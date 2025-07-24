module Sales
  class SalesOrdersController < ApplicationController
    include IdSearchQueryProcessor

    before_action :set_sales_order, only: %i[ show edit update destroy ]
    before_action :check_editable_status, only: %i[ edit update ]
    before_action :check_workable_status, only: %i[ show ]

    # GET /sales_orders or /sales_orders.json
    def index
      @q = SalesOrder.ransack(params[:q])
      @q.sorts = default_sort if @q.sorts.empty?
      @sales_orders = @q.result
        .includes(:products, :client, :sales_order_items)
        .page(params[:page])
    end

    # GET /sales_orders/1 or /sales_orders/1.json
    def show
    end

    # GET /sales_orders/new
    def new
      @sales_order = SalesOrder.new(client_id: client_id_from_params)
      @sales_order.sales_order_items.build
    end

    # GET /sales_orders/1/edit
    def edit
    end

    # POST /sales_orders or /sales_orders.json
    def create
      @sales_order = SalesOrder.new(sales_order_params)

      respond_to do |format|
        if @sales_order.save && confirm_if_requested
          format.html { redirect_to [ :sales, @sales_order ], notice: t(".success") }
          format.json { render :show, status: :created, location: [ :sales, @sales_order ] }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @sales_order.errors, status: :unprocessable_entity }
        end
      end
    end

    def preview_totals
      @sales_order = SalesOrder.new(sales_order_params)

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "sales_order_totals_preview",
            partial: "sales/sales_orders/sales_order_totals",
            locals: { sales_order: @sales_order }
          )
        end
        format.html { render :preview, status: :ok }
        format.json { render :preview, status: :ok, location: [ :sales, @sales_order ] }
      end
    end

    # PATCH/PUT /sales_orders/1 or /sales_orders/1.json
    def update
      respond_to do |format|
        if @sales_order.update(sales_order_params) && confirm_if_requested
          format.html { redirect_to [ :edit, :sales, @sales_order ], notice: t(".success") }
          format.json { render :show, status: :ok, location: [ :sales, @sales_order ] }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @sales_order.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /sales_orders/1 or /sales_orders/1.json
    def destroy
      @sales_order.destroy!

      respond_to do |format|
        format.html { redirect_to sales_sales_orders_path, status: :see_other, notice: t(".success") }
        format.json { head :no_content }
      end
    end

    private

    def confirm_if_requested
      return true unless confirm_param?

      @sales_order.confirm!
    end

    def check_workable_status
      unless @sales_order.workable?
        redirect_to edit_sales_sales_order_path(@sales_order)
      end
    end

    def check_editable_status
      unless @sales_order.editable?
        redirect_to sales_sales_order_path(@sales_order)
      end
    end

    def set_sales_order
      @sales_order = SalesOrder.find(params.expect(:id))
    end

    def sales_order_params
      params.require(:sales_order).permit(
        :cash_discount_percentage,
        :client_discount_percentage,
        :client_id,
        :comments,
        :id,
        sales_order_items_attributes: [
          :_destroy,
          :id,
          :product_id,
          :quantity,
          :unit_price,
        ]
      )
    end

    def default_sort
      [ "id desc" ]
    end

    def client_id_from_params
      if params[:client_id].present?
        params[:client_id]
      elsif params[:sales_order].present? && params[:sales_order][:client_id].present?
        params[:sales_order][:client_id]
      else
        redirect_to sales_sales_orders_path, alert: "Client ID is required to create a sales order."
      end
    end

    def confirm_param?
      params[:commit] == "confirm"
    end
  end
end
