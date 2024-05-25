class Chat < ApplicationRecord
  belongs_to :application
  has_many :messages

  validates :number, presence: true
end
