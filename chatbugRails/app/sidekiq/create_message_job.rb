class CreateMessageJob
  include Sidekiq::Job

  def perform(args)
    message_args = JSON.parse(args)
    body = message_args["body"]
    message_number = message_args["number"]
    chat_number = message_args["chat_number"]
    application_token = message_args["application_token"]

    chat = Chat.find_by_application_token_and_chat_number(application_token, chat_number)
    if chat.nil?
      Rails.logger.error "CreateMessageJob: chat number: #{chat_number} in application #{application_token} not found"
      return
    end

    message = Message.new(body: body, number: message_number, chat: chat)
    if message.save
      Rails.logger.info "CreateMessageJob: created message number: #{message_number} for chat numer: #{chat_number} for application #{application_token}"
    else
      Rails.logger.error "CreateMessageJob: error creating message number: #{message_number} for chat numer: #{chat_number} for application #{application_token}"
    end
  end
end
