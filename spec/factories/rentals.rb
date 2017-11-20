FactoryBot.define do
  factory :rental do
    name { Faker::Company.name }
    daily_rate 10

    factory :rental_with_bookings do
      transient do
        bookings_count 5
      end

      after(:create) do |rental, evaluator|
        create_list(:booking, evaluator.bookings_count, rental: rental)
      end
    end
  end
end
