FactoryBot.define do
  factory :making_order_formula_item do
    making_order_formula_id { 1 }
    formula_item_id { 1 }
    formula_element_id { 1 }
    formula_element_name { "MyString" }
    proportion { "9.99" }
    consumed_stock { "9.99" }
  end
end
