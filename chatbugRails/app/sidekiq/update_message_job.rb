class UpdateMessageJob
  include Sidekiq::Job

  def perform(args)
    message_args = JSON.parse(args)
    text = message_args["text"]
    message_number = message_args["number"]
    chat_number = message_args["chat_number"]
    application_token = message_args["application_token"]

    message = Message.find_by_application_token_and_chat_number_and_message_number(application_token, chat_number, message_number)
    if message.nil?
      Rails.logger.error "UpdateMessageJob: message number: #{message_number} in chat number: #{chat_number} in application #{application_token} not found"
      return
    end

    message.text = text
    if message.save
      Rails.logger.info "UpdateMessageJob: updated message number: #{message_number} in chat number: #{chat_number} in application #{application_token}"
    else
      Rails.logger.error "UpdateMessageJob: error updataing message number: #{message_number} in chat number: #{chat_number} in application #{application_token}"
    end
  end
end
