# frozen_string_literal: true

require "rails_helper"

module Maintenance
  RSpec.describe SplitProductIntoPolymorphicAssociationsTask do
    describe "#process" do
      subject(:process) { described_class.process(element) }
      let(:formula_element) { create(:formula_element, current_stock: 100) }
      let(:formula) { create(:formula, formula_items: [ formula_item ]) }
      let(:formula_item) { build(:formula_item, formula_element: formula_element, proportion: 100) }
      let(:element) do
        product = Product.new({
          formula: formula,
          pressure: "high",
          shape: "square",
          size: "10x10",
          weight: 10.0,
        })
        product.save!(validate: false)
        product
      end

      it "creates a ManufacturedProductDetail" do
        expect { process }.to change(ManufacturedProduct, :count).by(1)
        expect(ManufacturedProduct.last.formula).to eq(formula)
        expect(ManufacturedProduct.last.pressure).to eq("high")
        expect(ManufacturedProduct.last.shape).to eq("square")
        expect(ManufacturedProduct.last.size).to eq("10x10")
        expect(ManufacturedProduct.last.weight).to eq(10.0)
        expect(ManufacturedProduct.last.product).to eq(element)
      end

      it "prevents creating a ManufacturedProduct if the product already has a productable" do
        element.productable = create(:manufactured_product)
        element.save

        expect { process }.not_to change(ManufacturedProduct, :count)
      end

      it "won't create a ManufacturedProduct if the product is not valid" do
        element.price = "zero"
        expect { process }.to raise_error(ActiveRecord::RecordInvalid)
        expect { process }.not_to change(ManufacturedProduct, :count)
      end
    end
  end
end
