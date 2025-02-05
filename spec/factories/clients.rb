FactoryBot.define do
  factory :client do
    name { "John Doe" }
    tax_identification { "20202020200" }
    address { "Home" }
    zipcode { "5500" }
    country { "Argentina" }
    province { "Mendoza" }
    maps_url { "" }
    phone { "https://maps.app.goo.gl/eFgrqGj8uBdXsgN87" }
    email { "email@email.com" }
    client_type { :regular }
  end
end
