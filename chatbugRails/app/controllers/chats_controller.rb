class ChatsController < ApplicationController
  before_action :authenticate_user, only: [:index]

  def index
    application_token = params[:application_token]
    application = Application.find_by(token: application_token)
    if application.nil?
      raise NotFoundError
    end

    chats = []
    application.chats.limit(params[:limit]).offset(params[:offset]).each do |chat|
      chats << decorate(chat)
    end

    render json: chats, status: :ok
  end


  private

  def decorate(chat)
    {
      number: chat.number,
      name: chat.name,
      messages_counter: chat.messages_counter
    }
  end
end
