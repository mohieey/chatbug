class MessagesController < ApplicationController
  before_action :authenticate_user, only: [:index]

  def index
    application_token = params[:application_token]
    chat_number = params[:chat_number]

    chat = Chat.find_by_application_token_and_chat_number(application_token, chat_number)
    if chat.nil?
      raise NotFoundError
    end

    messages = []
    chat.messages.limit(params[:limit]).offset(params[:offset]).each do |message|
      messages << decorate(message)
    end

    render json: messages, status: :ok
  end

  def search
    application_token = params[:application_token]
    chat_number = params[:chat_number]
    query = params[:q]

    chat = Chat.find_by_application_token_and_chat_number(application_token, chat_number)
    if chat.nil?
      raise NotFoundError
    end

    messages = []
    Message.search(query, chat.id).each do |message|
      messages << decorate(message)
    end

    render json: messages, status: :ok
  end


  private

  def decorate(message)
    {
      number: message.number,
      body: message.body,
    }
  end
end
