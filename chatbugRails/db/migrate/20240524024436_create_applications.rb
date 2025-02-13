class CreateApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :applications do |t|
      t.string :name
      t.string :token
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
