FactoryBot.define do
  factory :supplier do
    address { Faker::Address.full_address }
    bank_account_number { Faker::Bank.account_number(digits: 10) }
    bank_name { Faker::Bank.name }
    country { "Argentina" }
    email { Faker::Internet.email }
    maps_url { Faker::Internet.url }
    name { Faker::Company.name }
    phone { Faker::PhoneNumber.cell_phone }
    province { "Mendoza" }
    routing_number { Faker::Bank.routing_number }
    tax_identification { Faker::Company.ein }
    tax_type { [ :simplified_regime, :general_regime ].sample }
    zipcode { Faker::Address.zip_code }
  end
end
