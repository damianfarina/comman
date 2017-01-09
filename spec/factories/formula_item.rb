FactoryGirl.define do
  factory :formula_item do
    proportion 50.9
    formula

    factory :formula_item_with_element do
      before(:create) do |item, evaluator|
        item.formula_element = create(:formula_element)
      end
    end
  end
end
