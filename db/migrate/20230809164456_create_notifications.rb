class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :team_member, null: false, foreign_key: true
      t.text :message
      t.boolean :viewed, default: false

      t.timestamps
    end
  end
end
