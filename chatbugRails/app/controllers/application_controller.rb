class ApplicationController < ActionController::API
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
end
