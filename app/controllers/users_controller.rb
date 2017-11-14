class UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: :created
    else
      render json: { errors: ErrorSerializer.serialize(user) },
        status: :unprocessable_entity
    end
  end

  private

  def user_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params)
  end
end
