require 'rails_helper'

RSpec.describe FormulaElement, type: :model do
  it "should create a formula element" do
    element = create(:formula_element)
    expect(element.id).to be_present
  end
end
