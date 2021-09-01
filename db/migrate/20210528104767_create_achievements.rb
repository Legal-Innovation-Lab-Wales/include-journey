# db/migrate/20210528104767_create_achievements.rb
class CreateAchievements < ActiveRecord::Migration[6.1]
  def change
    create_table :achievements do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.string :resource, null: false
      t.date :starts_at
      t.date :ends_at
      t.integer :count, null: false, default: 0
      t.json :intervals

      t.timestamps
    end
  end
end
