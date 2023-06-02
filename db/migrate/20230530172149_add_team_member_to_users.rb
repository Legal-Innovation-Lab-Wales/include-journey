class AddTeamMemberToUsers < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :team_member, null: true, foreign_key: true
  end
end
