require 'rails_helper'

RSpec.describe "Factory::Formulas", type: :request do
  describe "GET /factory_formulas" do
    it "should list formulas" do
      create :formula
      get factory_formulas_path, params: {format: :json}
      expect(response).to have_http_status(200)
      expect(json.size).to eq(1)
    end
  end
end
