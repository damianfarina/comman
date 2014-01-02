# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :client_type do |f|
    f.name { Faker::Name.name }
    f.description { Faker::Lorem.paragraph }
  end
end
