require "rails_helper"

RSpec.describe "/office/settings", type: :request do
  before { sign_in create(:user) }

  describe "GET /index" do
    it "renders a successful response" do
      get office_settings_url
      expect(response).to be_successful
    end
  end
end
