FactoryBot.define do
  factory :booking do
    start_at Faker::Date.unique.between(2.days.from_now, 30.days.from_now)
    end_at Faker::Date.unique.between(30.days.from_now, 60.days.from_now)
    client_email "MyString"
    price "9.99"
    rental
  end
end
