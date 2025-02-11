module Office
  class DiscountsController < ApplicationController
    before_action :set_discount, only: [ :show, :edit, :update ]

    def show
    end

    def edit
    end

    def update
      if @discount.update(discount_params)
        redirect_to [ :office, @discount ]
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

      def discount_params
        params.require(:discount).permit(:percentage)
      end

      def set_discount
        @discount = Discount.find(params[:id])
      end
  end
end
