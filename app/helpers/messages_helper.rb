# app/helpers/messages_helper.rb
module MessagesHelper
  def alert_user_of_messages?
    current_user.messages.where(read: false).count.positive?
  end

  def archive_messages?
    older_dated_notes? || older_created_notes?
  end

  def older_dated_notes?
    current_user.notes.past_dated.joins(:message)
                .where(visible_to_user: true, replaced_by: nil).present?
  end

  def older_created_notes?
    current_user.notes.past_created.joins(:message)
                .where(visible_to_user: true, replaced_by: nil).present?
  end
end
