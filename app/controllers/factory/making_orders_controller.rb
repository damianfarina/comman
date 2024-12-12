module Factory
  class MakingOrdersController < ApplicationController
    before_action :set_making_order, only: %i[ show edit update destroy ]

    # GET /making_orders or /making_orders.json
    def index
      @q = MakingOrder.ransack(params[:q] || default_sort)
      @making_orders = @q
        .result(distinct: true)
        .joins(:making_order_formula)
        .includes(:making_order_formula, :making_order_items)
        .page(params[:page])
    end

    # GET /making_orders/1 or /making_orders/1.json
    def show
    end

    # GET /making_orders/new
    def new
      @making_order = MakingOrder.new
    end

    # GET /making_orders/1/edit
    def edit
    end

    # POST /making_orders or /making_orders.json
    def create
      @making_order = MakingOrder.new(making_order_params)

      respond_to do |format|
        if @making_order.save
          format.html { redirect_to @making_order, notice: "Making order was successfully created." }
          format.json { render :show, status: :created, location: @making_order }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @making_order.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /making_orders/1 or /making_orders/1.json
    def update
      respond_to do |format|
        if @making_order.update(making_order_params)
          format.html { redirect_to @making_order, notice: "Making order was successfully updated." }
          format.json { render :show, status: :ok, location: @making_order }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @making_order.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /making_orders/1 or /making_orders/1.json
    def destroy
      @making_order.destroy!

      respond_to do |format|
        format.html { redirect_to making_orders_path, status: :see_other, notice: "Making order was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_making_order
        @making_order = MakingOrder.find(params.expect(:id))
      end

      # Only allow a list of trusted parameters through.
      def making_order_params
        params.expect(making_order: [ :total_weight, :weight_per_round, :rounds_count, :comments, :mixer_capacity, :state ])
      end

      def default_sort
        { s: "id desc" }
      end
  end
end
