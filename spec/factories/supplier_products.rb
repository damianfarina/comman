FactoryBot.define do
  factory :supplier_product do
    code { Faker::Alphanumeric.alpha(number: 10) }
    price { Faker::Commerce.price }
  end
end
