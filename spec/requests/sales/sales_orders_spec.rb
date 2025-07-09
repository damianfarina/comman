require 'rails_helper'

RSpec.describe "/sales_orders", type: :request do
  before { sign_in create(:user) }

  describe "GET /index" do
    it "renders a successful response" do
      create(:sales_order)
      get sales_orders_url
      expect(response).to be_successful
    end
  end
end
