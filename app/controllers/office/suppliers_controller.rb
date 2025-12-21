module Office
  class SuppliersController < ApplicationController
    include IdSearchQueryProcessor

    before_action :set_supplier, only: %i[ show edit update destroy ]

    # GET /office/suppliers or /office/suppliers.json
    def index
      @q = Supplier.ransack(params[:q])
      @q.sorts = default_sort if @q.sorts.empty?
      @suppliers = @q.result.page(params[:page])
    end

    # GET /office/suppliers/1 or /office/suppliers/1.json
    def show
      @audit_logs = @supplier.audit_logs.recent.includes(:user)
      @q = @supplier.supplied_products.ransack(params[:q])
      @q.sorts = default_sort if @q.sorts.empty?
      @supplied_products = @q.result.page(params[:page])
    end

    # GET /office/suppliers/new
    def new
      @supplier = Supplier.new
    end

    # GET /office/suppliers/1/edit
    def edit
    end

    # POST /office/suppliers or /office/suppliers.json
    def create
      @supplier = Supplier.new(supplier_params)

      respond_to do |format|
        if @supplier.save
          format.html { redirect_to [ :office, @supplier ], notice: "Supplier was successfully created." }
          format.json { render :show, status: :created, location: @supplier }
        else
          format.html { render :new, status: :unprocessable_content }
          format.json { render json: @supplier.errors, status: :unprocessable_content }
        end
      end
    end

    # PATCH/PUT /office/suppliers/1 or /office/suppliers/1.json
    def update
      respond_to do |format|
        if @supplier.update(supplier_params)
          format.html { redirect_to [ :office, @supplier ], notice: "Supplier was successfully updated." }
          format.json { render :show, status: :ok, location: @supplier }
        else
          format.html { render :edit, status: :unprocessable_content }
          format.json { render json: @supplier.errors, status: :unprocessable_content }
        end
      end
    end

    # DELETE /office/suppliers/1 or /office/suppliers/1.json
    def destroy
      @supplier.destroy!

      respond_to do |format|
        format.html { redirect_to office_suppliers_path, status: :see_other, notice: "Supplier was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_supplier
        @supplier = Supplier.find(params.expect(:id))
      end

      # Only allow a list of trusted parameters through.
      def supplier_params
        params.expect(supplier: [
          :address,
          :bank_account_number,
          :bank_name,
          :comments,
          :country,
          :email,
          :maps_url,
          :name,
          :phone,
          :province,
          :routing_number,
          :tax_identification,
          :tax_type,
          :zipcode,
        ])
      end

      def default_sort
        [ "name asc" ]
      end
  end
end
