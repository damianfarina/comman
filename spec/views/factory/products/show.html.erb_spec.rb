require 'rails_helper'

RSpec.describe "factory/products/show", type: :view do
  before(:each) do
    @formula = create(:formula)
    @product = assign(:product, Product.create!(
      price: 12.4,
      formula_id: @formula.id,
      shape: 'RuedaRecta',
      size: '350x115x24',
      weight: 123.4,
      pressure: 'C50'
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/12.4/)
    expect(rendered).to match(/#{@formula.name}/)
    expect(rendered).to match(/RuedaRecta/)
    expect(rendered).to match(/350x115x24/)
    expect(rendered).to match(/123.4/)
    expect(rendered).to match(/C50/)
  end
end
