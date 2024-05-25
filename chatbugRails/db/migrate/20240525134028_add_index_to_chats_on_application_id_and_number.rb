class AddIndexToChatsOnApplicationIdAndNumber < ActiveRecord::Migration[7.1]
  def change
    add_index :chats, [:application_id, :number]
  end
end
