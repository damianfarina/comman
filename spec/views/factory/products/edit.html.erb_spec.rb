require 'rails_helper'

RSpec.describe "factory/products/edit", type: :view do
  before(:each) do
    @formula = create(:formula)
    @product = assign(:product, Product.create!(
      name: "Name",
      price: 12.4,
      formula_id: @formula.id,
      shape: 'RR',
      size: '350x115x24',
      weight: 1.4,
      pressure: 'C50'
    ))
  end

  it "renders the edit product form" do
    render

    assert_select "form[action=?][method=?]", factory_product_path(@product), "post" do
      assert_select "input#product_price[name=?]", "product[price]"
      assert_select "select#product_formula_id[name=?]", "product[formula_id]"
      assert_select "input#product_shape[name=?]", "product[shape]"
      assert_select "input#product_size[name=?]", "product[size]"
      assert_select "input#product_weight[name=?]", "product[weight]"
      assert_select "input#product_pressure[name=?]", "product[pressure]"
    end
  end
end
