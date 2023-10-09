# app/helpers/notifications_helper.rb
module NotificationsHelper
  def alert_team_member_of_notifications?
    current_team_member && current_team_member.notifications.where(viewed: false, upload_id: nil).count.positive?
  end

  # Predicate method to be used to be view
  # Alerts users of all notifications
  def alert_user_of_notification?
    current_user && (new_uploads_for_user? || new_messages_for_user?)
  end

  # Predicate method to be used in view
  # Alerts users of messages notification
  def new_messages_for_user?
    user_messages_count.positive?
  end

  # Predicate method to be used in view
  # Alerts users of new file uploads by team_members
  def new_uploads_for_user?
    unviewed_user_uploads_notification_count.positive?
  end

  # Do user upload notifications exist?
  def user_upload_notification_exist?
    user_upload_notification.count.positive?
  end

  private

  # ALL UPLOAD NOTIFICATION METHODS
  # All notification associated with the current user and uploads(files)
  def user_upload_notification
    current_user.notifications.where.not(upload: nil).order(created_at: :desc)
  end

  # All the upload notifications that user has not seen
  def unviewed_user_upload_notification
    user_upload_notification.where(viewed: false)
  end

  # All the viewed upload notification that user has seen
  def viewed_user_upload_notification
    user_upload_notification.where(viewed: true)
  end

  # Unseen notification count
  def unviewed_user_uploads_notification_count
    unviewed_user_upload_notification.count
  end

  # ALL MESSAGES NOTIFICATION METHODS
  # The messages functionality was built earlier before the notification feature,
  # that is why it's configuration is different from uploads notification's.
  # However, it is recommended that future features that are associated with
  # the notification feature should follow the uploads configuration.

  # All unseen user messages
  def user_messages_count
    current_user.messages.where(read: false).count
  end
end
