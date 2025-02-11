module Office
  class SettingsController < ApplicationController
    def index
      @cash_discount = Discount.cash.first
      @client_type_discounts = Discount.client_type
    end
  end
end
