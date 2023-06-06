class RemoveTeamMemberReferenceFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_reference :users, :team_member, foreign_key: true
  end
end
