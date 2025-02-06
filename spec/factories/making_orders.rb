FactoryBot.define do
  factory :making_order do
    comments { Faker::Lorem.sentence }
    mixer_capacity { 60.0 }
    state { :in_progress }

    trait :with_products do
      transient do
        products_count { 2 }
      end

      after(:build) do |making_order, evaluator|
        making_order.making_order_formula = build(
          :making_order_formula,
          formula: create(:formula, :with_items),
        )

        making_order.making_order_items = build_list(
          :making_order_item,
          evaluator.products_count,
          :with_product,
          making_order: making_order,
        )
      end
    end
  end
end
