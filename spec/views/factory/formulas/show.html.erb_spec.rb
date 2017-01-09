require 'rails_helper'

RSpec.describe "factory/formulas/show", type: :view do
  before(:each) do
    assign(:formula, Formula.create!(
      :abrasive => "Abrasive",
      :grain => "Grain",
      :hardness => "Hardness",
      :porosity => "Porosity",
      :alloy => "Alloy"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Abrasive/)
    expect(rendered).to match(/Grain/)
    expect(rendered).to match(/Hardness/)
    expect(rendered).to match(/Porosity/)
    expect(rendered).to match(/Alloy/)
  end
end
