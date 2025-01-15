module Factory
  class MakingOrdersController < ApplicationController
    before_action :set_making_order, only: %i[ show edit update destroy ]
    before_action :set_products, only: %i[ new create edit update destroy ]

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
      @making_order.making_order_items.build
    end

    # GET /making_orders/1/edit
    def edit
    end

    # POST /making_orders or /making_orders.json
    def create
      @making_order = MakingOrder.new(making_order_params)

      respond_to do |format|
        if @making_order.save
          format.html { redirect_to factory_making_order_path(@making_order), notice: "Making order was successfully created." }
          format.json { render :show, status: :created, location: factory_making_order_url(@making_order) }
        else
          @making_order.making_order_items.build
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @making_order.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /making_orders/1 or /making_orders/1.json
    def update
      respond_to do |format|
        if @making_order.update(making_order_params)
          format.html { redirect_to factory_making_order_path(@making_order), notice: "Making order was successfully updated." }
          format.json { render :show, status: :ok, location: factory_making_order_url(@making_order) }
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
      def set_making_order
        @making_order = MakingOrder.find(params.expect(:id))
      end

      def set_products
        @products = Product.order(:name)
      end

      def making_order_params
        params.expect(
          making_order: [
            :comments,
            :mixer_capacity,
            making_order_items_attributes: [
              [
                :id,
                :product_id,
                :quantity,
                :_destroy,
              ],
            ],
          ],
        )
      end

      def default_sort
        { s: "id desc" }
      end
  end
end
