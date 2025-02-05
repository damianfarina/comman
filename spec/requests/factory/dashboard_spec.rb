require 'rails_helper'

RSpec.describe "Factory::Dashboards", type: :request do
  before { sign_in create(:user) }

  describe "GET /index" do
    it "returns http success" do
      get "/factory"
      expect(response).to have_http_status(:success)
    end
  end
end
