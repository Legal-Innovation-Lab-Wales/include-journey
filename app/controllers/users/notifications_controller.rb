module Users
  # app/controllers/users/notifications_controller.rb
  class NotificationsController < UsersApplicationController
    before_action :set_breadcrumbs

    def index
      render 'index'
    end

    private

    def set_breadcrumbs
      add_breadcrumb('My Notifications', nil, 'fas fa-bell')
    end
  end
end
