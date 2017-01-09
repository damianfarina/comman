require 'rails_helper'

RSpec.describe "factory/products/new", type: :view do
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

  it "renders the new product form" do
    render

    assert_select "form[action=?][method=?]", factory_product_path(@product), "post" do
      assert_select "input#product_weight[name=?]", "product[weight]"
      assert_select "input#product_price[name=?]", "product[price]"
      assert_select "input#product_shape[name=?]", "product[shape]"
    end
  end
end
