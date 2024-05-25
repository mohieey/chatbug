class Message < ApplicationRecord
  belongs_to :chat

  validates :number, presence: true
end
