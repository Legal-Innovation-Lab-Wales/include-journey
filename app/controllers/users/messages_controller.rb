module Users
  # app/controllers/users/messages_controller.rb
  class MessagesController < UsersApplicationController
    def index
      add_breadcrumb('Message', nil, 'fas fa-envelope')
      @messages = Note.where(visible_to_user: true, user: current_user)
    end
  end
end
