FactoryBot.define do
  factory :race_edition do
    association :race
    name { '10K' }
    distance { 10 }
    price { 30000 }
    capacity { 100 }
    current_count { 0 }
  end
end
