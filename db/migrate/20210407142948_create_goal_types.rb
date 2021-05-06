# db/migrate/20210407142948_create_goal_types.rb
class CreateGoalTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :goal_types do |t|
      t.text :name, null: false
      t.text :emoji, null: false

      t.timestamps
    end
  end
end
