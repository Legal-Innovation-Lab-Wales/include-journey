class CreateTeamMemberNotificationFrequency < ActiveRecord::Migration[6.1]
  def change
    create_table :team_member_notification_frequencies do |t|
      t.string :accommodation_status, default: '6 months'
      t.string :wellbeing_assessment, default: '3 months'
      t.references :team_member, null: false, foreign_key: true

      t.timestamps
    end
  end
end
