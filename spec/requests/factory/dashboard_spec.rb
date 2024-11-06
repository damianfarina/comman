require 'rails_helper'

RSpec.describe "Factory::Dashboards", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/factory/dashboard/index"
      expect(response).to have_http_status(:success)
    end
  end

end
