class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :team_member, null: true, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.text :message
      t.boolean :viewed, default: false

      t.timestamps
    end
  end
end
