# db/migrate/20210407142948_create_goals.rb
class CreateGoals < ActiveRecord::Migration[6.1]
  def change
    create_table :goals do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.text :goal, null: false
      t.datetime :achieved_on

      t.timestamps
    end
  end
end
