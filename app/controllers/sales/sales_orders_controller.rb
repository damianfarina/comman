module Sales
  class SalesOrdersController < ApplicationController
    include IdSearchQueryProcessor

    before_action :set_sales_order, only: %i[ show edit update destroy ]

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
      @sales_order = SalesOrder.new
    end

    # GET /sales_orders/1/edit
    def edit
    end

    # POST /sales_orders or /sales_orders.json
    def create
      @sales_order = SalesOrder.new(sales_order_params)

      respond_to do |format|
        if @sales_order.save
          format.html { redirect_to @sales_order, notice: "Sales order was successfully created." }
          format.json { render :show, status: :created, location: @sales_order }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @sales_order.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /sales_orders/1 or /sales_orders/1.json
    def update
      respond_to do |format|
        if @sales_order.update(sales_order_params)
          format.html { redirect_to @sales_order, notice: "Sales order was successfully updated." }
          format.json { render :show, status: :ok, location: @sales_order }
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
        format.html { redirect_to sales_orders_path, status: :see_other, notice: "Sales order was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    private

    def set_sales_order
      @sales_order = SalesOrder.find(params.expect(:id))
    end

    def sales_order_params
      params.expect(
        sales_order: [
          :client_id,
          :status,
          :confirmed_at,
          :fulfilled_at,
          :cancelled_at,
          :total_price,
          :comments_plain_text,
          :cash_discount_percentage,
          :client_discount_percentage,
        ])
    end

    def default_sort
      [ "id desc" ]
    end
  end
end
