class Notification < ApplicationRecord
  belongs_to :team_member, optional: true
  belongs_to :user, optional: true
  belongs_to :upload, optional: true

  def self.create_for_all_teammembers
    TeamMember.find_each do |team_member|
      team_member.users.find_each do |user|
        create_user_notification(team_member, user)
      end
    end
  end

  def self.create_user_notification(team_member, user)
    if user.created_at.to_date == 6.months.ago.to_date || should_create_notification?(user)
      Notification.create!(
        team_member: team_member,
        message: 'Please check the accommodation status for:',
        user: user
      )
    end
  end

  def self.should_create_notification?(user)
    user_notifications = Notification.where(
      user_id: user.id,
      message: 'Please check the accommodation status for:'
    )

    user.created_at.to_date < 6.months.ago.to_date && (user_notifications.empty? || user_notifications.last.created_at.to_date == 6.months.ago.to_date)
  end
end
