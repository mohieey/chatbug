class Chat < ApplicationRecord
  belongs_to :application
  has_many :messages

  validates :number, presence: true
  validates :name, presence: true, length: { minimum: 3 }

  def self.find_by_application_token_and_chat_number(application_token, chat_number)
    joins(:application).where(applications: { token: application_token }, chats: { number: chat_number }).first
  end
end
