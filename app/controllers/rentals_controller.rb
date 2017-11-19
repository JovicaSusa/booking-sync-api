class RentalsController < ApplicationController
  skip_before_action :authorize_request, except: [:create, :update, :destroy]
  before_action :set_rental, only: [:show, :update, :destroy]

  def index
    rentals = Rental.all
    render json: rentals, status: :ok
  end

  def show
    render json: @rental, include: ['bookings'], status: :ok
  end

  def create
    rental = Rental.new(rental_params)
    if rental.save
      render json: rental, status: :created
    else
      render json: rental,
        status: :unprocessable_entity,
        serializer: ActiveModel::Serializer::ErrorSerializer
    end
  end

  def update
    @rental.update(rental_params)
    head :no_content
  end

  def destroy
    @rental.destroy
    head :no_content
  end

  private

  def set_rental
    @rental = Rental.find(params[:id])
  end

  def rental_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params)
  end
end
