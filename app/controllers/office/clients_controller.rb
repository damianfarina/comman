module Office
  class ClientsController < ApplicationController
    def index
      @q = Client.ransack(params[:q] || default_sort)
      @clients = @q.result.page(params[:page])
    end

    private

      def default_sort
        { s: "name asc" }
      end
  end
end
