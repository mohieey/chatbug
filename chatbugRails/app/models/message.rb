class Message < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  mappings do
    indexes :body, type: 'text', analyzer: 'english'
    indexes :chat_id, type: 'integer'
  end

  def self.search(query, chat_id)
    params = {
      query: {
        bool: {
          must: [
            { match: { chat_id: chat_id } },
            {
              multi_match: {
                query: query,
                fields: ['body'],
                fuzziness: "AUTO"
              }
            }
          ]
        }
      }
    }

    self.__elasticsearch__.search(params).records.to_a
  end

  belongs_to :chat

  validates :number, presence: true

  def self.find_by_application_token_and_chat_number_and_message_number(application_token, chat_number, message_number)
    joins(chat: :application).where(chats: { number: chat_number }, applications: { token: application_token }, messages: { number: message_number }).first
  end
end
