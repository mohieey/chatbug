class UpdateChatJob
  include Sidekiq::Job

  def perform(args)
    chat_args = JSON.parse(args)
    application_token = chat_args["application_token"]
    chat_number = chat_args["number"]
    chat_name = chat_args["name"]

    chat = Chat.find_by_application_token_and_chat_number(application_token, chat_number)
    if chat.nil?
      Rails.logger.error "UpdateChatJob: chat number: #{chat_number} in application #{application_token} not found"
      return
    end

    chat.name = chat_name
    if chat.save
      Rails.logger.info "UpdateChatJob: updated chat number: #{chat_number} for application #{application_token}"
    else
      Rails.logger.error "UpdateChatJob: error updataing chat number: #{chat_number} for application #{application_token}"
    end
  end
end
