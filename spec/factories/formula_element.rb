FactoryGirl.define do
  factory :formula_element do
    sequence :name do |n|
      "Formula-#{n}-Element"
    end

    min_stock 100
    current_stock 150
    infinite false
  end
end
