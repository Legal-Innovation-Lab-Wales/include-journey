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
    notification_types = %i[accommodation_status wellbeing_assessment]
    notification_types.each do |type|
      frequency = notification_frequency(team_member)[type]
      next unless user.created_at.to_date == frequency || should_create_notification?(user, type, frequency)

      Notification.create!(team_member: team_member,
                           message: notification_message[type],
                           user: user)
    end
  end

  def self.should_create_notification?(user, type, frequency)
    user_notifications = Notification.where(
      user_id: user.id,
      message: notification_message[type]
    )

    user.created_at.to_date < frequency && (user_notifications.empty? || user_notifications.last.created_at.to_date == frequency)
  end

  def self.notification_frequency(team_member)
    accommodation_status_freqency = team_member.team_member_notification_frequency.accommodation_status.to_i
    wellbeing_assessment_frequency = team_member.team_member_notification_frequency.wellbeing_assessment.to_i
    { accommodation_status: accommodation_status_freqency.months.ago.to_date,
      wellbeing_assessment: wellbeing_assessment_frequency.months.ago.to_date }
  end

  def self.notification_message
    {
      accommodation_status: 'Please check the accommodation status for:',
      wellbeing_assessment: 'Please perform wellbeing assessment for:'
    }
  end
end
