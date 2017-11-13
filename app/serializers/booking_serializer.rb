class BookingSerializer < ActiveModel::Serializer
  attributes :id, :start_at, :end_at, :client_email, :price

  belongs_to :rental
end
