FactoryBot.define do
  factory :making_order do
    comments { Faker::Lorem.sentence }
    mixer_capacity { 60.0 }
    state { :in_progress }
    transient do
      formula { association :formula, :with_items }
    end
    transient do
      formula_id { formula&.id }
    end
    making_order_formula do
      association :making_order_formula, formula: formula, formula_id: formula_id, making_order: instance
    end

    trait :with_products do
      transient do
        products_count { 2 }
      end
      making_order_items do
        Array.new(products_count) do
          association :making_order_item, :with_product, making_order: instance, formula: formula
        end
      end
    end
  end
end
