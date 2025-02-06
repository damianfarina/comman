FactoryBot.define do
  factory :product do
    price { Faker::Commerce.price }
    formula
    shape { Faker::Alphanumeric.alpha(number: 2) }
    size { "#{ Faker::Number.number(digits: 2)}x#{ Faker::Number.number(digits: 2)}x#{ Faker::Number.number(digits: 2)}" }
    weight { Faker::Number.number(digits: 2) }
    pressure { "G#{Faker::Number.number(digits: 2)}" }
  end
end
