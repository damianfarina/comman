FactoryBot.define do
  factory :sales_order, class: "Sales::Order" do
    client { association :client }
    status { :quote }

    transient do
      products_count { 0 }
    end

    after(:build) do |order, evaluator|
      if evaluator.products_count > 0
        order.items = build_list(:sales_order_item, evaluator.products_count, :with_product, order: order)
      end
    end
  end
end
