class Booking < ApplicationRecord
  belongs_to :rental

  validates_presence_of :start_at, :end_at, :client_email, :price, :rental
end
