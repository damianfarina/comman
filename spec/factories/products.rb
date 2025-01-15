FactoryBot.define do
  factory :product do
    name { Faker::Commerce.unique.product_name }
    price { Faker::Commerce.price }
    formula
    shape { "RR" }
    size { "250x100x50" }
    weight { 10.0 }
    pressure { "G100" }
  end
end
