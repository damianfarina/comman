FactoryBot.define do
  factory :sales_order_item do
    sales_order
    product
    quantity { 2 }
    unit_price { nil }
    status { :quote }

    trait :with_product do
      product { association :purchased_productable }
    end
  end
end
