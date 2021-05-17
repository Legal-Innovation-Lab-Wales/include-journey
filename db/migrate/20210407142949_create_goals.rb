# db/migrate/20210407142949_create_goals.rb
class CreateGoals < ActiveRecord::Migration[6.1]
  def change
    create_table :goals do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :goal_type, null: false, foreign_key: true
      t.text :goal, null: false
      t.boolean :short_term, null: false, default: true
      t.datetime :achieved_on
      t.boolean :archived, null: false, default: false

      t.timestamps
    end
  end
end
