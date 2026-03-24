FactoryBot.define do
  factory :organizer_profile do
    association :user
    business_name { Faker::Company.name }
    contact_email { Faker::Internet.email }
    contact_phone { Faker::PhoneNumber.phone_number }
  end
end
