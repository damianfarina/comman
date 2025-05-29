FactoryBot.define do
  factory :sales_order_item do
    sales_order { association :sales_order }
    product { association :product }
    quantity { 2 }
    unit_price { product.price * quantity }
    status { SalesOrderItem.statuses.keys.sample }
  end
end
