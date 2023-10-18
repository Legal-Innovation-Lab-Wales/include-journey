# app/models/notification.rb
class Notification < ApplicationRecord
  belongs_to :team_member, optional: true
  belongs_to :user, optional: true
  belongs_to :upload, optional: true

  CHECKUP_TYPES = [
    'accommodation_status',
    'wellbeing_assessment',
    nil
  ].freeze

  TIME_UNITS = [
    'seconds',
    'minutes',
    'hours',
    'days',
    'weeks',
    'months',
    'years',
    nil
  ].freeze

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
    accommodation_status_freqency = team_member.team_member_notification_frequency.accommodation_status
    wellbeing_assessment_frequency = team_member.team_member_notification_frequency.wellbeing_assessment
    { accommodation_status: convert_to_duration(accommodation_status_freqency).ago.to_date,
      wellbeing_assessment: convert_to_duration(wellbeing_assessment_frequency).ago.to_date }
  end

  def self.notification_message
    {
      accommodation_status: 'Please check the accommodation status for:',
      wellbeing_assessment: 'Please perform wellbeing assessment for:'
    }
  end

  def self.convert_to_duration(duration)
    quantity, unit = duration.split(' ')
    quantity = quantity.to_i
    unit = unit.singularize
    unit_to_method = { 'second' => :seconds, 'minute' => :minutes, 'hour' => :hours,
                       'day' => :days, 'week' => :weeks, 'month' => :months, 'year' => :years }

    duration_method = unit_to_method[unit] || :seconds
    quantity.send(duration_method)
  end
end
