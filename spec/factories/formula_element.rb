FactoryGirl.define do
  sequence :name do |n|
    "Formula Element #{n}"
  end

  factory :formula_element do
    name
    min_stock 100
    current_stock 150
    infinite false
  end
end
