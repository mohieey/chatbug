class AddMessagesCounterToChats < ActiveRecord::Migration[7.1]
  def change
    add_column :chats, :messages_counter, :integer, default: 0
  end
end
