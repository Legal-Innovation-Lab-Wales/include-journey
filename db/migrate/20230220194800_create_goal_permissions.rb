class CreateGoalPermissions < ActiveRecord::Migration[6.1]
  def change
    create_table :goal_permissions do |t|
      t.boolean :short_term, :default => false
      t.boolean :long_term, :default => false
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :team_member, null: false, foreign_key: true

      t.timestamps
    end
  end
end
