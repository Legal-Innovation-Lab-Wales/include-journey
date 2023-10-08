# app/helpers/notifications_helper.rb
module NotificationsHelper
  def alert_team_member_of_notifications?
    current_team_member && current_team_member.notifications.where(viewed: false, upload_id: nil).count.positive?
  end

  def alert_user_of_notification?
    current_user && (new_messages_for_user? || new_uploads_for_user?)
  end

  def user_messages_count
    current_user.messages.where(read: false).count
  end

  def user_uploads_count
    current_user.notifications.where.not(upload: nil, viewed: false).count
  end

  def new_messages_for_user?
    current_user.messages.where(read: false).count.positive?
  end

  def new_uploads_for_user?
    current_user.notifications.where.not(upload: nil, viewed: true).count.positive?
  end
end
