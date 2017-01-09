require 'rails_helper'

RSpec.describe "factory/formulas/index", type: :view do
  before(:each) do
    Formula.create!(
      :abrasive => "Abrasive1",
      :grain => "Grain",
      :hardness => "Hardness",
      :porosity => "Porosity",
      :alloy => "Alloy"
    )
    Formula.create!(
      :abrasive => "Abrasive2",
      :grain => "Grain",
      :hardness => "Hardness",
      :porosity => "Porosity",
      :alloy => "Alloy"
    )
    @search = Formula.search
    assign(:search, @search)
    assign(:formulas, @search.result.page(1))
  end

  it "renders a list of factory/formulas" do
    render
    assert_select "tr>td", :text => "Abrasive1GrainHardnessPorosityAlloy".to_s, :count => 1
    assert_select "tr>td", :text => "Abrasive2GrainHardnessPorosityAlloy".to_s, :count => 1
    assert_select "tr>td", :text => "Abrasive1".to_s, :count => 1
    assert_select "tr>td", :text => "Abrasive2".to_s, :count => 1
    assert_select "tr>td", :text => "Grain".to_s, :count => 2
    assert_select "tr>td", :text => "Hardness".to_s, :count => 2
    assert_select "tr>td", :text => "Porosity".to_s, :count => 2
    assert_select "tr>td", :text => "Alloy".to_s, :count => 2
  end
end
