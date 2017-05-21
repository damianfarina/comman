FactoryGirl.define do

  factory :formula_element do
    sequence(:name) { |n| "Formula Element #{n}" }
    min_stock 100
    current_stock 150
    infinite false
  end

end
