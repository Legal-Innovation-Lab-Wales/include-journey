class CreateWbaTeamMemberScores < ActiveRecord::Migration[6.1]
  def change
    create_table :wba_team_member_scores do |t|
      t.integer :value
      t.integer :priority
      t.belongs_to :wba_team_member, null: false, foreign_key: true
      t.belongs_to :wellbeing_metric, null: false, foreign_key: true

      t.timestamps
    end
  end
end
