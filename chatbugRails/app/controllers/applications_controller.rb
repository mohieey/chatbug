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
      REDIS.hset(APPS_TOKENS_TO_APPS_IDS_MAP_KEY, application.token, application.id)
      render json: decorate(application), status: :created
    else
      render json: application.errors, status: :bad_request
    end
  end

  def update
    application_token = params[:application_token]
    name = params[:name]

    application = Application.find_by(token: application_token)
    if application.nil?
      raise NotFoundError
    end

    application.name = name
    if application.save
      render status: :no_content
    else
      render status: :unprocessable_entity
    end
  end

  private

  def decorate(application)
    {
      application_name: application.name,
      application_token: application.token,
      chats_counter: application.chats_counter,
    }
  end
end
