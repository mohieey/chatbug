class Application < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, length: { minimum: 3 }
  validates :token, presence: true, uniqueness: true, length: { is: 16 }

  before_validation :generate_token, on: :create

  private

  def generate_token
    self.token = SecureRandom.hex(8)
  end
end
