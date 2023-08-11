module TeamMembers
  # app/controllers/team_members/notifications_controller.rb
  class NotificationsController < AdminApplicationController
    before_action :set_breadcrumbs
    after_action :update_notifications_to_read
    
    def index
      @notifications = current_team_member.notifications.where(viewed: false)
    end

    private
    def update_notifications_to_read
      return unless current_team_member.notifications.where(viewed: false).present?

      current_team_member.notifications.each do |notification|
        notification.update!(viewed: true)
      end
    end
    def set_breadcrumbs
      add_breadcrumb('My Notifications', nil, 'fas fa-bell')
    end
  end
end
