class Rental < ApplicationRecord
  validates_presence_of :name, :daily_rate

  has_many :bookings, dependent: :destroy
end
