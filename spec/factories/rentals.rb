FactoryBot.define do
  factory :rental do
    name { Faker::Company.name }
    daily_rate 10
  end
end
