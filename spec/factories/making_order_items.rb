FactoryBot.define do
  factory :making_order_item do
    making_order
    product
    quantity { 1 }

    trait :with_product do
      transient do
        product { create(:product, formula: making_order.formula) }
      end

      after(:build) do |making_order_item, evaluator|
        making_order_item.product = evaluator.product
      end
    end
  end
end
