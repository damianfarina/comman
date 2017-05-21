FactoryGirl.define do
  factory :formula_item do
    proportion 50.9

    factory :formula_item_with_element do
      after(:build) do |item, evaluator|
        item.formula_element = create(:formula_element)
      end
    end
  end
end
