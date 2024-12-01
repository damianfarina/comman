FactoryBot.define do
  factory :formula do
    abrasive { Faker::Alphanumeric.alphanumeric(number: 2, min_alpha: 2).upcase }
    grain { Faker::Alphanumeric.alphanumeric(number: 2, min_alpha: 2).upcase }
    hardness { Faker::Alphanumeric.alphanumeric(number: 2, min_alpha: 2).upcase }
    porosity { Faker::Alphanumeric.alphanumeric(number: 2, min_alpha: 2).upcase }
    alloy { Faker::Alphanumeric.alphanumeric(number: 2, min_alpha: 2).upcase }

    trait :with_items do
      transient do
        items_count { 2 }
        items_proportions { [ 30.0, 70.0 ] }
      end

      after(:build) do |formula, evaluator|
        evaluator.items_proportions.each do |proportion|
          formula.formula_items << build(
            :formula_item,
            formula: formula,
            formula_element: create(:formula_element),
            proportion: proportion,
          )
        end
      end
    end
  end
end
