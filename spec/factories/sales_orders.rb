FactoryBot.define do
  factory :sales_order do
    client { association :client }
    status { SalesOrder.statuses.keys.sample }
  end
end
