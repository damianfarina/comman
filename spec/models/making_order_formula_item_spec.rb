require 'rails_helper'

describe MakingOrderFormulaItem, type: :model do
  let(:formula_element) { create(:formula_element, current_stock: 100) }
  let(:formula) { create(:formula, formula_items: [ formula_item ]) }
  let(:formula_item) { build(:formula_item, formula_element: formula_element, proportion: 100) }
  let(:product) { create(:product, formula: formula) }
  let(:making_order_formula) { build(:making_order_formula, formula: formula, making_order_formula_items: [ making_order_formula_item ]) }
  let(:making_order_formula_item) { build(:making_order_formula_item, formula_item: formula_item, proportion: 100) }
  let(:making_order_item) { build(:making_order_item, product: product) }
  let!(:making_order) { create(:making_order, making_order_formula: making_order_formula, making_order_items: [ making_order_item ]) }

  before do
    making_order_formula_item.save
  end

  describe 'callbacks' do
    context 'before_save' do
      it 'calculates consumed stock' do
        expect(making_order_formula_item.consumed_stock).to eq(10.0)
      end
    end

    context 'after_create' do
      it 'takes formula element stock' do
        expect(formula_element.reload.current_stock).to eq (90.0)
      end
    end

    context 'after_update' do
      it 'updates formula element stock' do
        making_order.making_order_items.first.update(quantity: 2)
        making_order.save
        expect(making_order_formula_item.reload.consumed_stock).to eq(20.0)
        expect(formula_element.reload.current_stock).to eq (80.0)
      end
    end

    context 'after_destroy' do
      it 'gives back formula element stock' do
        making_order_formula_item.destroy
        expect(formula_element.reload.current_stock).to eq(100.0)
      end
    end
  end
end
