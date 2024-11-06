FactoryBot.define do
  factory :formula_item do
    association :formula
    association :formula_element
    proportion { 9.99 }
  end
end
