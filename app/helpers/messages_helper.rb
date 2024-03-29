# app/helpers/messages_helper.rb
module MessagesHelper
  def alert_user_of_messages?
    current_user.messages.where(read: false).count.positive?
  end

  def archive_messages?
    current_user.notes.past.joins(:message)
                .where(visible_to_user: true, replaced_by: nil).present?
  end
end
