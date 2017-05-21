FactoryGirl.define do

  factory :formula do
    sequence :abrasive do |n|
      "#{n}A"
    end
    grain '20.3'
    hardness 'R'
    porosity '6'
    alloy 'BAK'

    factory :formula_with_items do
      transient do
        items_count 5
      end

      before(:create) do |formula, evaluator|
        formula.formula_items = build_list :formula_item_with_element,
          evaluator.items_count,
          formula: formula,
          proportion: 100.0 / evaluator.items_count
      end
    end
  end
end
