class Chat < ApplicationRecord
  belongs_to :application
  has_many :messages

  validates :number, presence: true
  validates :name, presence: true, length: { minimum: 3 }
end
