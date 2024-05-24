class ApplicationsController < ApplicationController
  include ApplicationParams
  before_action :authenticate_user, only: [:create]

  def create
    application = Application.new(application_params.merge(user_id: @current_user.id))

    if application.save
      render json: decorate(application), status: :created
    else
      render json: application.errors, status: :bad_request
    end
  end

  def decorate(application)
    {
      application_name: application.name,
      application_token: application.token,
    }
  end
end
