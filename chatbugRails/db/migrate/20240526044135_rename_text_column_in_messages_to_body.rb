class RenameTextColumnInMessagesToBody < ActiveRecord::Migration[7.1]
  def change
    rename_column :messages, :text, :body
  end
end
