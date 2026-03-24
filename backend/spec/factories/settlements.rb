FactoryBot.define do
  factory :settlement do
    association :organizer_profile
    association :race
    total_revenue { 1_000_000 }
    registration_count { 20 }
    platform_commission { 60_000 }
    organizer_payout { 940_000 }
    status { 'pending' }

    trait :confirmed do
      status { 'confirmed' }
    end

    trait :approved do
      status { 'approved' }
    end

    trait :paid do
      status { 'paid' }
    end

    trait :rejected do
      status { 'rejected' }
    end
  end
end
