class UsersController < ApplicationController
  def create
    user = User.new(user_params)
    # TODO Add error scenario
    user.save
    render json: user, status: :created
  end

  private

  def user_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params)
  end
end
