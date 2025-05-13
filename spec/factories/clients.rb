FactoryBot.define do
  factory :client do
    address { Faker::Address.full_address }
    client_type { [ :regular, :hardware_store, :distributor ].sample }
    country { "Argentina" }
    email { Faker::Internet.email }
    maps_url { "https://maps.app.goo.gl/eFgrqGj8uBdXsgN87" }
    name { Faker::Company.name }
    phone { Faker::PhoneNumber.cell_phone }
    province { "Mendoza" }
    seller_name { Faker::Name.name }
    tax_identification { Faker::Company.ein }
    tax_type { [ :final_consumer, :simplified_regime, :general_regime ].sample }
    zipcode { Faker::Address.zip_code }
  end
end
