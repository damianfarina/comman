require 'rails_helper'

RSpec.describe Formula, type: :model do
  it "should create a formula with 5 elements" do
    formula = create(:formula_with_items)
    expect(formula.formula_items.count).to eq(5)
  end
end
