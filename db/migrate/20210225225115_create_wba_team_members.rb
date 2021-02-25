class CreateWbaTeamMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :wba_team_members do |t|
      t.belongs_to :team_member, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
