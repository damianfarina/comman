require 'rails_helper'

RSpec.describe FormulaElement, type: :model do
  describe "#stock_level" do
    it "returns 100 if infinite is true" do
      formula_element = FormulaElement.new(infinite: true, min_stock: 10, current_stock: 5)
      expect(formula_element.stock_level).to eq(100)
    end

    it "returns 0 if min_stock is zero" do
      formula_element = FormulaElement.new(min_stock: 0, current_stock: 5)
      expect(formula_element.stock_level).to eq(0)
    end

    it "calculates the correct percentage for valid stock" do
      formula_element = FormulaElement.new(min_stock: 10, current_stock: 5)
      expect(formula_element.stock_level).to eq(50)
    end

    it "caps stock level at 0 for negative stock" do
      formula_element = FormulaElement.new(min_stock: 10, current_stock: -5)
      expect(formula_element.stock_level).to eq(0)
    end
  end

  describe ".by_stock_level" do
    let!(:element1) { create(:formula_element, current_stock: 50, min_stock: 100) } # Stock Level: 50%
    let!(:element2) { create(:formula_element, current_stock: 200, min_stock: 100) } # Stock Level: 200%
    let!(:element3) { create(:formula_element, current_stock: 25, min_stock: 100) } # Stock Level: 25%

    it "sorts elements by stock level in ascending order" do
      result = FormulaElement.by_stock_level(:asc)
      expect(result).to eq([ element3, element1, element2 ])
    end

    it "sorts elements by stock level in descending order" do
      result = FormulaElement.by_stock_level(:desc)
      expect(result).to eq([ element2, element1, element3 ])
    end

    it "handles elements with zero min_stock" do
      element_with_zero_min_stock = create(:formula_element, current_stock: 50, min_stock: 0)
      result = FormulaElement.by_stock_level(:asc)
      expect(result).to include(element_with_zero_min_stock)
    end
  end

  describe "stock_level ransacker" do
    let!(:element1) { create(:formula_element, current_stock: 50, min_stock: 100) } # Stock Level: 50%
    let!(:element2) { create(:formula_element, current_stock: 200, min_stock: 100) } # Stock Level: 200%
    let!(:element3) { create(:formula_element, current_stock: 25, min_stock: 100) } # Stock Level: 25%

    it "sorts elements by stock level in ascending order" do
      results = FormulaElement.ransack(s: "stock_level asc").result
      expect(results).to eq([ element3, element1, element2 ])
    end

    it "sorts elements by stock level in descending order" do
      results = FormulaElement.ransack(s: "stock_level desc").result
      expect(results).to eq([ element2, element1, element3 ])
    end

    it "handles elements with zero min_stock" do
      element_with_zero_min_stock = create(:formula_element, current_stock: 50, min_stock: 0)
      results = FormulaElement.ransack(s: "stock_level asc").result
      expect(results).to include(element_with_zero_min_stock)
    end

    it "filters elements based on stock level" do
      results = FormulaElement.ransack(stock_level_gteq: 100).result
      expect(results).to match_array([ element2 ])
    end

    it "returns a stock level of 100 when infinite is true" do
      infinite_element = create(:formula_element, infinite: true, current_stock: 50, min_stock: 100)
      expect(FormulaElement.ransack(stock_level_eq: 100).result).to include(infinite_element)
    end
  end

  describe "before_validation :clear_current_stock_if_infinite" do
    it "clears current_stock when infinite is true" do
      formula_element = FormulaElement.new(current_stock: 100, infinite: true)
      formula_element.valid? # Trigger validations
      expect(formula_element.current_stock).to be_nil
    end

    it "does not clear current_stock when infinite is false" do
      formula_element = FormulaElement.new(current_stock: 100, infinite: false)
      formula_element.valid? # Trigger validations
      expect(formula_element.current_stock).to eq(100)
    end
  end
end
