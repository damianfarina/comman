FactoryBot.define do
  factory :formula_element do
    name { "Magnesium" }
    min_stock { 10.0 }
    current_stock { 11.5 }
    infinite { false }
  end
end