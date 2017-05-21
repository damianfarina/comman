require 'faker'

FactoryGirl.define do
  factory :making_order do
    comments { Faker::Lorem.sentence }
    mixer_capacity { 60 }
  end
end
