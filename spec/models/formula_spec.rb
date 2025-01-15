require 'rails_helper'

describe Formula, type: :model do
  it "is valid with valid attributes" do
    formula = build(:formula, :with_items)
    expect(formula).to be_valid
  end

  it "is not valid without an abrasive" do
    formula = build(:formula, abrasive: nil)
    expect(formula).not_to be_valid
    expect(formula.errors[:abrasive]).to include("no puede estar en blanco")
  end

  it "is not valid without a grain" do
    formula = build(:formula, grain: nil)
    expect(formula).not_to be_valid
    expect(formula.errors[:grain]).to include("no puede estar en blanco")
  end

  it "is not valid without a hardness" do
    formula = build(:formula, hardness: nil)
    expect(formula).not_to be_valid
    expect(formula.errors[:hardness]).to include("no puede estar en blanco")
  end

  it "is not valid without a porosity" do
    formula = build(:formula, porosity: nil)
    expect(formula).not_to be_valid
    expect(formula.errors[:porosity]).to include("no puede estar en blanco")
  end

  it "is not valid without an alloy" do
    formula = build(:formula, alloy: nil)
    expect(formula).not_to be_valid
    expect(formula.errors[:alloy]).to include("no puede estar en blanco")
  end

  it "is not valid without formula items" do
    formula = build(:formula, formula_items: [])
    expect(formula).not_to be_valid
    expect(formula.errors[:formula_items]).to include("no puede estar en blanco")
  end

  it "is not valid with duplicated formula elements" do
    element = create(:formula_element)
    formula = build(:formula, formula_items: build_list(:formula_item, 2, formula_element: element))
    expect(formula).not_to be_valid
    expect(formula.errors[:base]).to include(I18n.t(:duplicated_formula_elements, scope: [ :activerecord, :errors, :models, :formula ]))
  end

  it "is not valid if items proportion is not one hundred" do
    formula = build(:formula, formula_items: build_list(:formula_item, 2, proportion: 30))
    expect(formula).not_to be_valid
    expect(formula.errors[:base]).to include(I18n.t(:proportion_must_be_one_hundred, scope: [ :activerecord, :errors, :models, :formula ], difference: 40.0))
  end

  it "is not valid if name is not unique" do
    create(:formula, :with_items, abrasive: "A", grain: "B", hardness: "C", porosity: "D", alloy: "E")
    formula = build(:formula, :with_items, abrasive: "A", grain: "B", hardness: "C", porosity: "D", alloy: "E")
    expect(formula).not_to be_valid
    expect(formula.errors[:base]).to include(I18n.t(:name_must_be_unique, scope: [ :activerecord, :errors, :models, :formula ], other_formula_id: Formula.find_by_name("ABCDE").id, other_formula_name: "ABCDE"))
  end
end
