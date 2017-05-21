FactoryGirl.define do

  factory :product do
    shape 'RR'
    sequence(:size) { |n| "#{(n + 115) % 600}x#{(n + 12) % 60}x#{n % 76}" }
    sequence(:weight) { |n| n * 1.2 }
    sequence(:price) { |n| n + 50 }
    sequence :pressure do |n|
      
      # ABCDEFG
      ((n % 7) + 65).chr
    end
    association :formula, factory: :formula_with_items
  end
end
