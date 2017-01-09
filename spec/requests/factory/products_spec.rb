require 'rails_helper'

RSpec.describe "Products", :type => :request do
  describe "GET /factory/products" do
    it "works! (now write some real specs)" do
      create :product
      get factory_products_path
      expect(response).to have_http_status(200)
    end
  end
end
