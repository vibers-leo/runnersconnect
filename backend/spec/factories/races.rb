FactoryBot.define do
  factory :race do
    title { Faker::Lorem.sentence(word_count: 3) }
    description { Faker::Lorem.paragraph }
    location { Faker::Address.full_address }
    start_at { 2.months.from_now }
    status { 'open' }
    registration_start_at { 1.week.ago }
    registration_end_at { 1.month.from_now }

    trait :draft do
      status { 'draft' }
    end

    trait :closed do
      status { 'closed' }
    end

    trait :finished do
      status { 'finished' }
    end

    trait :registration_closed do
      registration_start_at { 2.months.ago }
      registration_end_at { 1.month.ago }
    end

    trait :with_organizer do
      association :organizer, factory: :organizer_profile
    end

    trait :with_editions do
      after(:create) do |race|
        create(:race_edition, race: race, name: '10K', distance: 10, price: 30000)
        create(:race_edition, race: race, name: '5K', distance: 5, price: 20000)
      end
    end
  end
end
