# db/migrate/20210528104766_create_sessions.rb
class CreateSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :sessions do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.date :session_at, null: false

      t.timestamps
    end
  end
end
