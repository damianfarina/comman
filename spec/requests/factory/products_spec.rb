require 'rails_helper'

RSpec.describe "Factory::Products", :type => :request do

  describe "GET /factory/products" do
    it "should list products" do
      create :product
      get factory_products_path, params: {format: :json}
      expect(response).to have_http_status(200)
      expect(json.size).to eq(1)
    end
  end

  describe "GET /factory/products/autocomplete" do
    before :each do
      create_list(:product, 3)
    end

    it "should find product by term" do
      product = Product.first

      get autocomplete_factory_products_path,
        params: { term: product.name }

      expect(json.size).to eq(1)
      expect(json.first['id']).to eq(product.id)
      expect(json.first['value']).to eq(product.name)
      expect(json.first['formula_id']).to eq(product.formula_id)
    end

    it "should find product with formula and term" do
      product = Product.first

      get autocomplete_factory_products_path,
        params: { term: product.pressure, formula_id: product.formula_id}

      expect(json.size).to eq(1)
      expect(json.first['id']).to eq(product.id)
      expect(json.first['value']).to eq(product.name)
      expect(json.first['formula_id']).to eq(product.formula_id)
    end

    it "should return no results if term/formula does not match" do
      product = Product.first

      get autocomplete_factory_products_path,
        params: { term: product.pressure, formula_id: '9999999'}

      expect(json.size).to eq(0)

      get autocomplete_factory_products_path,
        params: { term: 'invalid_term', formula_id: product.formula_id}
      expect(json.size).to eq(0)
    end

    it "should return no results if no product matches" do
      get autocomplete_factory_products_path,
        params: { term: 'invalid_term' }

      expect(json.size).to eq(0)
    end

  end
end
