class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.string :text
      t.integer :number
      t.references :chat, null: false, foreign_key: true

      t.timestamps
    end
  end
end
