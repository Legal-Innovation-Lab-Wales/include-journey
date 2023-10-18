class AddTeamMemberReferencesToTeamMemberNotificationFrequency < ActiveRecord::Migration[6.1]
  def change
    add_reference :team_member_notification_frequencies, :team_member, null: false, foreign_key: true

    TeamMember.find_each(&:create_team_member_notification_frequency)
  end
end
