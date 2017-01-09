require 'rails_helper'

RSpec.describe "factory/formulas/new", type: :view do
  before(:each) do
    formula = Formula.new(
      :abrasive => "MyString",
      :grain => "MyString",
      :hardness => "MyString",
      :porosity => "MyString",
      :alloy => "MyString"
    )
    formula.formula_items.build
    assign(:formula, formula)
  end

  it "renders new factory_formula form" do
    render

    assert_select "form[action=?][method=?]", factory_formulas_path, "post" do
      assert_select "input#formula_abrasive[name=?]", "formula[abrasive]"
      assert_select "input#formula_grain[name=?]", "formula[grain]"
      assert_select "input#formula_hardness[name=?]", "formula[hardness]"
      assert_select "input#formula_porosity[name=?]", "formula[porosity]"
      assert_select "input#formula_alloy[name=?]", "formula[alloy]"

      assert_select "select#formula_formula_items_attributes_0_formula_element_id[name=?]",
        "formula[formula_items_attributes][0][formula_element_id]"
      assert_select "input#formula_formula_items_attributes_0_proportion[name=?]",
        "formula[formula_items_attributes][0][proportion]"
    end
  end
end
