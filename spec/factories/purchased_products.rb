FactoryBot.define do
  factory :purchased_product do
    base_cost { Faker::Commerce.price }
  end
end
