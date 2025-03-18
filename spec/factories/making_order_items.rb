FactoryBot.define do
  factory :making_order_item do
    quantity { 1 }
    product
    making_order

    trait :with_making_order do
      transient do
        formula { association :formula, :with_items }
      end
      making_order { association :making_order, formula: formula, making_order_items: [ instance ] }
    end

    trait :with_product do
      transient do
        formula { making_order.formula }
      end
      product { association :manufactured_productable, formula: formula }
    end
  end
end
