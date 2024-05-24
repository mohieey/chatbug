class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token

  class AuthenticaionError < StandardError; end

  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from AuthenticaionError, with: :handle_unauthenticated

  private

  def parameter_missing(e)
    render json: { error: e.message }, status: :bad_request
  end

  def handle_unauthenticated
    head :unauthorized
  end

  def authenticate_user
    begin
      token, _options = token_and_options(request)
      user_id = AuthTokenService.decode(token)
      @current_user = User.find(user_id)
    rescue
      render status: :unauthorized
    end
  end
end
