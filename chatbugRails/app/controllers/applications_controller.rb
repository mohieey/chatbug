class ApplicationsController < ApplicationController
  include ApplicationParams
  before_action :authenticate_user, only: [:index, :create]

  def index
    applications = []
    @current_user.applications.find_each do |application|
      applications << decorate(application)
    end

    render json: applications, status: :ok
  end

  def create
    application = Application.new(application_params.merge(user_id: @current_user.id))

    if application.save
      render json: decorate(application), status: :created
    else
      render json: application.errors, status: :bad_request
    end
  end

  private

  def decorate(application)
    {
      application_name: application.name,
      application_token: application.token,
    }
  end
end
