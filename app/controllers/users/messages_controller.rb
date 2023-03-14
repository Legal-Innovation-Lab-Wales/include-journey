module Users
  # app/controllers/users/messages_controller.rb
  class MessagesController < UsersApplicationController
    after_action :update_messages_to_read

    def index
      add_breadcrumb('Message', nil, 'fas fa-envelope')
      @messages = current_user.notes.joins(:message).order('dated DESC, created_at DESC').where(visible_to_user: true, replaced_by: nil)
      @notifications = current_user.messages
    end

    private

    def update_messages_to_read
      return unless current_user.messages.where(read: false).present?

      current_user.messages.each do |message|
        message.update!(read: true)
      end
    end
  end
end
