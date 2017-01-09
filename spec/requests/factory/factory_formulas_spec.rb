require 'rails_helper'

RSpec.describe "Factory::Formulas", type: :request do
  describe "GET /factory_formulas" do
    it "works! (now write some real specs)" do
      get factory_formulas_path
      expect(response).to have_http_status(200)
    end
  end
end
