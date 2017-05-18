require 'rails_helper'

RSpec.describe "Factory::FormulaElement", :type => :request do

  describe "GET /factory/formula_elements" do
    it "works! (now write some real specs)" do
      create :formula_element
      get factory_formula_elements_path, params: {format: :json}
      expect(response).to have_http_status(200)
      expect(json.size).to eq(1)
    end
  end

  describe "GET /factory/formula_elements/autocomplete" do
    before :each do
      create_list(:formula_element, 3)
    end

    it "should find product by term" do
      element = FormulaElement.first
      get autocomplete_factory_formula_elements_path,
        params: { term: element.name }
      expect(json.size).to eq(1)
      expect(json.first['id']).to eq(element.id)
      expect(json.first['value']).to eq(element.name)
    end

    it "should return no results if no product matches" do
      get autocomplete_factory_formula_elements_path,
        params: { term: 'invalid_term' }
      expect(json.size).to eq(0)
    end

  end
end
