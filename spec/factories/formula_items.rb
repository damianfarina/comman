FactoryBot.define do
  factory :formula_item do
    formula
    formula_element
    proportion { 50 }

    trait :with_element do
      formula_element { association :formula_element }
    end
  end
end
