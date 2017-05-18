FactoryGirl.define do
  factory :product do
    shape 'CPL'
    sequence :size do |n|
      "#{(n % 350) + 115}X50X22"
    end
    sequence :weight do |n|
      "1.#{n}".to_f
    end
    pressure 'C-20'
    sequence :price do |n|
      n + 100.0
    end
    formula
  end
end
