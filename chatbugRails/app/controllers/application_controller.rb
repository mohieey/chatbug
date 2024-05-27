class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token

  class AuthenticaionError < StandardError; end
  class NotFoundError < StandardError; end

  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from AuthenticaionError, with: :handle_unauthenticated
  rescue_from NotFoundError, with: :handle_notfound
  rescue_from ActiveRecord::RecordNotFound, with: :handle_notfound

  private

  def parameter_missing(e)
    render json: { error: e.message }, status: :bad_request
  end

  def handle_unauthenticated
    head :unauthorized
  end

  def handle_notfound
    head :not_found
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
