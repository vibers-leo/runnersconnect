FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { 'password123' }
    password_confirmation { 'password123' }
    role { 'user' }

    trait :admin do
      role { 'admin' }
    end

    trait :organizer do
      role { 'organizer' }
      after(:create) do |user|
        create(:organizer_profile, user: user) unless user.organizer_profile
      end
    end

    trait :staff do
      role { 'staff' }
    end
  end
end
