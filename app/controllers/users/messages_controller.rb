module Users
  # app/controllers/users/messages_controller.rb
  class MessagesController < UsersApplicationController
    def index
      add_breadcrumb('Message', nil, 'fas fa-envelope')
      @messages = Note.order(dated: :desc, created_at: :desc).where(visible_to_user: true, user: current_user)
    end
  end
end
