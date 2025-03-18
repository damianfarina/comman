FactoryBot.define do
  factory :manufactured_product do
    pressure { "G#{Faker::Number.number(digits: 2)}" }
    shape { Faker::Alphanumeric.alpha(number: 2) }
    size { "#{ Faker::Number.number(digits: 2)}x#{ Faker::Number.number(digits: 2)}x#{ Faker::Number.number(digits: 2)}" }
    weight { Faker::Number.number(digits: 2) }
    formula { association :formula, :with_items }
  end
end
