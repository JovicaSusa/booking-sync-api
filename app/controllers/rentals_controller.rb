class RentalsController < ApplicationController
  before_action :set_rental, only: [:show, :update, :destroy]

  def index
    rentals = Rental.all
    render json: rentals, status: :ok
  end

  def show
    render json: @rental, status: :ok
    # TODO: Handle ActiveRecordNotFound situation
  end

  def create
    rental = Rental.new(rental_params)
    rental.save
    render json: rental, status: :created
    # TODO: Handle create fail
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
