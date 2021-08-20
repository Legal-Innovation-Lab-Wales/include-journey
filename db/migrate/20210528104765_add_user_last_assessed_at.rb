# db/migrate/20210528104765_add_user_last_assessed_at.rb
class AddUserLastAssessedAt < ActiveRecord::Migration[6.1]
  def change
    change_table :users do |t|
      t.datetime :last_assessed_at
    end
  end
end
