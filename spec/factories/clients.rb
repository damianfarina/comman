require 'faker'

FactoryGirl.define do
  factory :client do |f|
    f.name { Faker::Name.name }
    f.address { "#{Faker::Address.street_address}" }
    f.zip_code { Faker::Address.zip_code }
    f.balance { Faker::Number.number(4) }
    f.admission_date { DateTime.now }
    f.client_type_id { ClientType.limit(1).order("RANDOM()").first.id }
    f.state { 'Mendoza' }
    f.country { 'Argentina' }
    f.phone_one { Faker::PhoneNumber.phone_number }
    f.phone_two { Faker::PhoneNumber.cell_phone }
    f.email_one { Faker::Internet.email }
  end
end
