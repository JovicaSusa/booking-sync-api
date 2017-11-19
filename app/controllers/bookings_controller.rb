class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :update, :destroy]

  def index
    bookings = Booking.all
    render json: bookings, status: :ok
  end

  def show
    render json: @booking, status: :ok
  end

  def create
    booking = Booking.new(booking_params)
    if booking.save
      render json: booking, status: :created
    else
      render json: booking,
        status: :unprocessable_entity,
        serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  def update
    @booking.update(booking_params)
    head :no_content
  end

  def destroy
    @booking.destroy
    head :no_content
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params)
  end
end
