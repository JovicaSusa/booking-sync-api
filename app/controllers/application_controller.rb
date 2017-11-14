class ApplicationController < ActionController::API
  include ErrorSerializer

  before_action :authorize_request

  private

  def authorize_request
    authorize || render_unauthorized
  end

  def authorize
    if request.headers['Authorization']
      token = request.headers['Authorization'].split(' ').last
      user_id = JwtHandler.decode(token)[:user_id]
      User.find_by(id: user_id)
    else
      render_unauthorized
    end
  end

  def render_unauthorized
    render json: { error: 'Not Authorized' }, status: unauthorized
  end
end
