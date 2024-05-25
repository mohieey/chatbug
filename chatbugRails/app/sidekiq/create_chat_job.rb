class CreateChatJob
  include Sidekiq::Job

  def perform(args)
    chat_args = JSON.parse(args)
    application_token = chat_args["application_token"]
    chat_number = chat_args["number"]
    chat_name = chat_args["name"]

    application = Application.find_by(token: application_token)
    if application.nil?
      Rails.logger.error "CreateChatJob: application #{application_token} not found"
      return
    end

    chat = Chat.new(number: chat_number, name: chat_name,application: application)
    if chat.save
      Rails.logger.info "CreateChatJob: created chat number: #{chat_number} for application #{application_token}"
    else
      Rails.logger.error "CreateChatJob: error creating chat number: #{chat_number} for application #{application_token}"
    end
  end
end
