FactoryBot.define do
  factory :making_order do
    total_weight { "9.99" }
    weight_per_round { "9.99" }
    rounds_count { 1 }
    comments { "MyText" }
    mixer_capacity { 1.5 }
    state { 1 }
  end
end
