class AuthenticationController < ApplicationController
  skip_before_action :authorize_request

  def create
    user = User.find_by_username(params[:username])
    if user && user.authenticate(params[:password])
      token = JwtHandler.encode(user_id: user.id)
      render json: { access_token: token }
    else
      render json: { errors: 'Invalid username or password' }
    end
  end
end
