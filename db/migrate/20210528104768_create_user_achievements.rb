# db/migrate/20210528104768_create_user_achievements.rb
class CreateUserAchievements < ActiveRecord::Migration[6.1]
  def change
    create_table :user_achievements do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :achievement, null: false, foreign_key: true
      t.boolean :bronze_achieved, null: false, default: false
      t.boolean :silver_achieved, null: false, default: false
      t.boolean :gold_achieved, null: false, default: false

      t.timestamps
    end
  end
end
