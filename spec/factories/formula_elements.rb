FactoryBot.define do
  factory :formula_element do
    name { "MyString" }
    min_stock { 1.5 }
    current_stock { 1.5 }
    infinite { false }
  end
end
