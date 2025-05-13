module Office
  class ClientsController < ApplicationController
    before_action :set_client, only: %i[ show edit update destroy]

    # GET /clients
    def index
      @q = Client.ransack(params[:q])
      @q.sorts = default_sort if @q.sorts.empty?
      @clients = @q.result.page(params[:page])
    end

    # GET /clients/1
    def show
    end

    # GET /clients/1/edit
    def edit
    end

    # PATCH/PUT /clients/1 or /clients/1.json
    def update
      respond_to do |format|
        if @client.update(client_params)
          format.html { redirect_to office_client_path(@client), notice: "El cliente fue actualizado." }
          format.json { render :show, status: :ok, location: office_client_url(@client) }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @client.errors, status: :unprocessable_entity }
        end
      end
    end

    # GET /clients/new
    def new
      @client = Client.new(default_client_params)
    end

    # POST /clients or /clients.json
    def create
      @client = Client.new(client_params)

      respond_to do |format|
        if @client.save
          format.html { redirect_to office_client_path(@client), notice: "El cliente fue creado." }
          format.json { render :show, status: :created, location: office_client_url(@client) }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @client.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /clients/1 or /clients/1.json
    def destroy
      raise "Clients cannot be destroyed! They are part of the company history. Implement archiving instead."
      @client.destroy!

      respond_to do |format|
        format.html { redirect_to office_clients_path, status: :see_other, notice: "Cliente eliminado." }
        format.json { head :no_content }
      end
    end

    private

      def default_client_params
        {
          client_type: :regular,
          country: ENV.fetch("DEFAULT_COUNTRY"),
          province: ENV.fetch("DEFAULT_PROVINCE"),
        }
      end

      def client_params
        params.expect(
          client: [
            :address,
            :client_type,
            :country,
            :email,
            :maps_url,
            :name,
            :phone,
            :province,
            :seller_name,
            :tax_identification,
            :tax_type,
            :zipcode,
          ],
        )
      end

      def set_client
        @client = Client.find(params[:id])
      end

      def default_sort
        [ "name asc" ]
      end
  end
end
