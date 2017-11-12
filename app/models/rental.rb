class Rental < ApplicationRecord
  validates_presence_of :name, :daily_rate
end
