FactoryBot.define do
  factory :registration do
    association :user
    association :race_edition
    merchant_uid { "#{Time.now.to_i}_#{SecureRandom.hex(4)}" }
    payment_amount { 30000 }
    status { 'pending' }

    trait :paid do
      status { 'paid' }
    end

    trait :cancelled do
      status { 'cancelled' }
    end

    trait :refunded do
      status { 'refunded' }
    end
  end
end
