module Office
  class UsersController < ApplicationController
    include IdSearchQueryProcessor

    before_action :set_user, only: %i[ show edit update destroy ]

    # GET /users or /users.json
    def index
      @q = User.ransack(params[:q])
      @q.sorts = default_sort if @q.sorts.empty?
      @users = @q.result.page(params[:page])
    end

    # GET /users/1 or /users/1.json
    def show
      @audit_logs = @user.audit_logs.recent
    end

    # GET /users/new
    def new
      @user = User.new
    end

    # GET /users/1/edit
    def edit
    end

    # POST /users or /users.json
    def create
      @user = User.new(user_params)

      respond_to do |format|
        if @user.save
          format.html { redirect_to [ :office, @user ], notice: t(".success") }
          format.json { render :show, status: :created, location: [ :office, @user ] }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    # PATCH/PUT /users/1 or /users/1.json
    def update
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to [ :office, @user ], notice: t(".success") }
          format.json { render :show, status: :ok, location: [ :office, @user ] }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /users/1 or /users/1.json
    def destroy
      raise "Users cannot be destroyed! They are part of the company history. Implement archiving instead."
      # Uncomment the line below to actually destroy the user
      # @user.destroy!

      respond_to do |format|
        format.html { redirect_to office_users_path, status: :see_other, notice: t(".success") }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(params.expect(:id))
      end

      # Only allow a list of trusted parameters through.
      def user_params
        params.expect(user: [ :name, :email_address, :cover ])
      end

      def default_sort
        [ "name desc" ]
      end
  end
end
