# app/helpers/notifications_helper.rb
module NotificationsHelper
  def alert_user_of_notifications?
    current_team_member && current_team_member.notifications.where(viewed: false).count.positive?
  end
end
