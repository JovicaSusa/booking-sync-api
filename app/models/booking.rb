class Booking < ApplicationRecord
  belongs_to :rental

  MIN_STAY = 1

  validates_presence_of :start_at, :end_at, :client_email, :price, :rental
  validate :validate_overlap,
    unless: Proc.new { |booking| booking.rental.nil? }
  validate :validate_period,
    if: Proc.new { |booking| booking.start_at && booking.end_at  }

  private

  def validate_overlap
    possible_overlap = rental.bookings.
      select { |booking| booking.id != id }.
      any? do |booking|
        start_at > booking.start_at && start_at < booking.end_at ||
        booking.start_at > start_at && booking.start_at < end_at
      end

    if possible_overlap
      errors.add(:start_at, 'Rental is already booked for this date')
      errors.add(:end_at, 'Rental is already booked for this date')
    end
  end

  def validate_period
    booking_period = ((end_at - start_at) / 1.day).round

    if booking_period <= MIN_STAY
      errors.add(:start_at, 'Booking period must be at least one/night day')
      errors.add(:end_at, 'Booking period must be at least one/night day')
    end
  end
end
