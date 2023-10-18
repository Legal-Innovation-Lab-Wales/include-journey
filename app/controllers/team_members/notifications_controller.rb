module TeamMembers
  # app/controllers/team_members/notifications_controller.rb
  class NotificationsController < AdminApplicationController
    before_action :set_breadcrumbs

    def index
      @notifications = current_team_member.notifications.where(viewed: false, upload_id: nil)
    end

    def update
      notification = Notification.where(id: params[:id])
      notification.update(viewed: true)

      redirect_to notifications_path
    end

    def update_notification_frequency
      team_member_notification_frequency = current_team_member.team_member_notification_frequency
      attribute_to_update = params[:check_up_type].to_sym
      team_member_notification_frequency.update!(attribute_to_update => "#{params[:frequency]} #{params[:time_unit]}")
      redirect_to notifications_path, notice: 'Notification frequency updated successfully.'
    end

    private

    def update_notifications_to_read
      return unless current_team_member.notifications.where(viewed: false, upload: nil).present?

      current_team_member.notifications.each do |notification|
        notification.update!(viewed: true)
      end
    end

    def set_breadcrumbs
      add_breadcrumb('My Notifications', nil, 'fas fa-bell')
    end
  end
end
