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
        making_order.making_order_products = build_list(:making_order_item, :with_product, evaluator.products_count, making_order: making_order)
      end
    end
  end
end
