require 'rails_helper'

RSpec.describe "factory/products/index", type: :view do
  before(:each) do
    formula = create(:formula)

    Product.create!(
      price: 1.4,
      formula_id: formula.id,
      shape: 'RRecta',
      size: '351x115x24',
      weight: 1.1,
      pressure: 'C40'
    )
    Product.create!(
      price: 2.4,
      formula_id: formula.id,
      shape: 'RuedaR',
      size: '350x115x24',
      weight: 1.2,
      pressure: 'C50'
    )

    @search = Product.search
    assign(:search, @search)
    assign(:products, @search.result.page(1))
  end

  it "renders a list of posts" do
    render
    assert_select "tr>td", :text => "RRecta", :count => 1
    assert_select "tr>td", :text => "RuedaR", :count => 1
    assert_select "tr>td", :text => "C40", :count => 1
    assert_select "tr>td", :text => "C50", :count => 1
  end
end
