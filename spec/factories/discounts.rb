FactoryBot.define do
  factory :discount do
    discount_type { :client_type }
    client_type { :regular }
    percentage { "10.0" }
  end
end
