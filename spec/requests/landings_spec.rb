require 'rails_helper'

RSpec.describe "Landing Page", type: :request do
  before { sign_in create(:user) }

  describe "GET /" do
    it "returns a successful response" do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end
end
