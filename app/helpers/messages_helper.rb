# app/helpers/messages_helper.rb
module MessagesHelper
  def alert_user_of_messages?
    current_user.messages.where(read: false).count.positive?
  end
end
