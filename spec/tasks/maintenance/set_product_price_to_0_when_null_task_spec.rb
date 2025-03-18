# frozen_string_literal: true

require "rails_helper"

module Maintenance
  RSpec.describe SetProductPriceTo0WhenNullTask do
    describe "#process" do
      subject(:process) { described_class.process(element) }
      let(:formula_element) { create(:formula_element, current_stock: 100) }
      let(:formula) { create(:formula, formula_items: [ formula_item ]) }
      let(:formula_item) { build(:formula_item, formula_element: formula_element, proportion: 100) }
      let(:element) do
        product = Product.new({
          formula: formula,
          price: 20.0,
        })
        product.save!(validate: false)
        product
      end

      it "sets the price to 0 if it is nil" do
        element.update_column(:price, nil)
        expect(element.reload.price).to be_nil
        process
        expect(element.reload.price).to eq(0)
      end

      it "skips the product if the price is not nil" do
        element.update_column(:price, 10)
        expect(element.reload.price).to eq(10)
        process
        expect(element.reload.price).to eq(10)
      end
    end
  end
end
