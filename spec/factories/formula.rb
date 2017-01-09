FactoryGirl.define do
  sequence :abrasive do |n|
    "#{n}A"
  end

  factory :formula do
    abrasive 'OA'
    grain '20.3'
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
