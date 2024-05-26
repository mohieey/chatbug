class UsersController < ApplicationController
  include UserParams

  def sign_up
    user = User.new(user_params)

    if user.save
      token = AuthTokenService.encode(user.id)
      render json: decorate(user, token), status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def sign_in
    user = User.find_by(username: user_params[:username])
    raise AuthenticaionError unless user.authenticate(user_params[:password])
    token = AuthTokenService.encode(user.id)

    render json: decorate(user, token), status: :created
  end

  def decorate(user, token)
    {
      username: user.username,
      token: token,
    }
  end
end
