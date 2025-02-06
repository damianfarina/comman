FactoryBot.define do
  factory :client do
    name { Faker::Company.name }
    tax_identification { Faker::Company.ein }
    address { Faker::Address.full_address }
    zipcode { Faker::Address.zip_code }
    country { "Argentina" }
    province { "Mendoza" }
    maps_url { "https://maps.app.goo.gl/eFgrqGj8uBdXsgN87" }
    phone { Faker::PhoneNumber.cell_phone }
    email { Faker::Internet.email }
    client_type { [ :regular, :distributor ].sample }
  end
end
