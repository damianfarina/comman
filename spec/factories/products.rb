FactoryBot.define do
  factory :product do
    price { Faker::Commerce.price }
  end

  factory :manufactured_productable, parent: :product do
    transient { formula { association :formula, :with_items } }
    transient { pressure { "G#{Faker::Number.number(digits: 2)}" } }
    transient { shape { Faker::Alphanumeric.alpha(number: 2) } }
    transient { size { "#{ Faker::Number.number(digits: 2)}x#{ Faker::Number.number(digits: 2)}x#{ Faker::Number.number(digits: 2)}" } }
    transient { weight { Faker::Number.number(digits: 2) } }
    productable { association :manufactured_product, formula: formula, pressure: pressure, shape: shape, size: size, weight: weight }
  end

  factory :purchased_productable, parent: :product do
    name { Faker::Commerce.product_name }
    transient { base_cost { Faker::Commerce.price } }
    productable { association :purchased_product, base_cost: base_cost }
  end
end
