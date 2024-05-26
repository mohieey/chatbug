class Message < ApplicationRecord
  belongs_to :chat

  validates :number, presence: true

  def self.find_by_application_token_and_chat_number_and_message_number(application_token, chat_number, message_number)
    joins(chat: :application).where(chats: { number: chat_number }, applications: { token: application_token }, messages: { number: message_number }).first
  end
end
