# db/migrate/20230310031659_create_messages.rb
class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.references :team_member, null: false, foreign_key: true, index: true
      t.integer :identifier
      t.boolean :read, default: false
      t.string :message_status

      t.timestamps
    end
  end
end
