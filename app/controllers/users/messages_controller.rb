module Users
  # app/controllers/users/messages_controller.rb
  class MessagesController < UsersApplicationController
    before_action :update_messages_to_read

    def index
      add_breadcrumb('Message', nil, 'fas fa-envelope')
      @messages = Note.order('dated DESC, created_at DESC')
                      .where(visible_to_user: true, user: current_user, replaced_by: nil)
      @message_notifications = current_user.messages
    end

    private

    def update_messages_to_read
      return unless current_user.messages.where(read: false).present?

      current_user.messages.update!(read: true)
    end
  end
end