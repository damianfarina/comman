require 'rails_helper'

RSpec.describe MakingOrderFormula, type: :model do
  describe 'prepare attributes before save' do
    let(:formula) { create(:formula, :with_items, items_count: 3, items_proportions: [ 10, 50, 40 ]) }
    let(:formula_item1) { formula.formula_items.first }
    let(:formula_item2) { formula.formula_items.second }
    let(:formula_item3) { formula.formula_items.third }
    let(:making_order) { create(:making_order, :with_products, formula: formula) }
    let(:making_order_formula) { build(:making_order_formula, formula: formula, making_order: making_order) }

    before { making_order_formula.valid? }

    it 'builds making_order_formula_items from formula items' do
      expect(making_order_formula.making_order_formula_items.first.proportion).to eq(formula_item1.proportion)
      expect(making_order_formula.making_order_formula_items.first.formula_element_id).to eq(formula_item1.formula_element_id)
      expect(making_order_formula.making_order_formula_items.first.formula_element_name).to eq(formula_item1.formula_element_name)
      expect(making_order_formula.making_order_formula_items.first.formula_item_id).to eq(formula_item1.id)
      expect(making_order_formula.making_order_formula_items.second.proportion).to eq(formula_item2.proportion)
      expect(making_order_formula.making_order_formula_items.second.formula_element_id).to eq(formula_item2.formula_element_id)
      expect(making_order_formula.making_order_formula_items.second.formula_element_name).to eq(formula_item2.formula_element_name)
      expect(making_order_formula.making_order_formula_items.second.formula_item_id).to eq(formula_item2.id)
      expect(making_order_formula.making_order_formula_items.third.proportion).to eq(formula_item3.proportion)
      expect(making_order_formula.making_order_formula_items.third.formula_element_id).to eq(formula_item3.formula_element_id)
      expect(making_order_formula.making_order_formula_items.third.formula_element_name).to eq(formula_item3.formula_element_name)
      expect(making_order_formula.making_order_formula_items.third.formula_item_id).to eq(formula_item3.id)
    end

    it 'does not build making_order_formula_items' do
      expect(making_order_formula.formula_name).to eq(formula.name)
      expect(making_order_formula.formula_abrasive).to eq(formula.abrasive)
      expect(making_order_formula.formula_grain).to eq(formula.grain)
      expect(making_order_formula.formula_hardness).to eq(formula.hardness)
      expect(making_order_formula.formula_porosity).to eq(formula.porosity)
      expect(making_order_formula.formula_alloy).to eq(formula.alloy)
    end
  end
end
