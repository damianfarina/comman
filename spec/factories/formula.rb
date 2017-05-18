FactoryGirl.define do

  factory :formula do
    sequence :abrasive do |n|
      "#{((n % 25) + 65).chr}"
    end
    sequence :grain do
      rand(10..120)
    end
    hardness 'R'
    porosity '6'
    alloy 'BAK'

    factory :formula_with_items do
      transient do
        items_count 5
      end

      before(:create) do |formula, evaluator|
        create_list(:formula_item_with_element, evaluator.items_count, formula: formula, proportion: 100.0 / 5.0)
      end
    end
  end
end
