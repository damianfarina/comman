require 'rails_helper'

RSpec.describe FormulaItem, type: :model do
  it "should create a formula item" do
    item = create(:formula_item_with_element, formula: create(:formula))
    expect(item.formula_element).to be_present
  end
end
