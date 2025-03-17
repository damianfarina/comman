FactoryBot.define do
  factory :formula do
    abrasive { Faker::Alphanumeric.alphanumeric(number: 2, min_alpha: 2).upcase }
    grain { Faker::Alphanumeric.alphanumeric(number: 2, min_alpha: 2).upcase }
    hardness { Faker::Alphanumeric.alphanumeric(number: 2, min_alpha: 2).upcase }
    porosity { Faker::Alphanumeric.alphanumeric(number: 2, min_alpha: 2).upcase }
    alloy { Faker::Alphanumeric.alphanumeric(number: 2, min_alpha: 2).upcase }

    trait :with_items do
      transient do
        items_count { 2 }
        items_proportions { [ 30.0, 70.0 ] }
      end

      formula_items do
        Array.new(items_count) do |index|
          association :formula_item, :with_element,
            formula: instance,
            proportion: items_proportions[index]
        end
      end
    end
  end
end
