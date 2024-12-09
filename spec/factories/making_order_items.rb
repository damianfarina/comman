FactoryBot.define do
  factory :making_order_item do
    making_order_id { 1 }
    product_id { 1 }
    quantity { 1 }
    product_name { "MyString" }
    product_shape { "MyString" }
    product_size { "MyString" }
    product_weight { "9.99" }
    product_pressure { "MyString" }
  end
end
