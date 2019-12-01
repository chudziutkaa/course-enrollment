FactoryBot.define do
  factory :user do
    email Faker::Internet.email
    password_digest Faker::Internet.password

    trait :worker do
      role 'worker'
    end
  end
end
