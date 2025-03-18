require 'rails_helper'

RSpec.describe MakingOrderItem, type: :model do
  it "stores product fields" do
    product = create(:manufactured_productable)
    making_order_item = create(:making_order_item, :with_making_order, product: product, formula: product.productable.formula)
    expect(making_order_item.product_name).to eq(making_order_item.product.name)
    expect(making_order_item.product_shape).to eq(making_order_item.product.productable.shape)
    expect(making_order_item.product_pressure).to eq(making_order_item.product.productable.pressure)
    expect(making_order_item.product_size).to eq(making_order_item.product.productable.size)
    expect(making_order_item.product_weight).to eq(making_order_item.product.productable.weight)
  end
end
