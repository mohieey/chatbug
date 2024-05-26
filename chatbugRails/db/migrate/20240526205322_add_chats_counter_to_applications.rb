class AddChatsCounterToApplications < ActiveRecord::Migration[7.1]
  def change
    add_column :applications, :chats_counter, :integer, default: 0
  end
end
