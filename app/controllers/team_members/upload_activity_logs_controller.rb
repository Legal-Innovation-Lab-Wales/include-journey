module TeamMembers
  # app/controllers/team_members/upload_activity_logs_controller.rb
  class UploadActivityLogsController < ApplicationController
    before_action :team_member
    before_action :set_breadcrumbs

    def index
    end

    private

    def team_member
      @team_member = TeamMember.includes(:upload_activity_logs).find(params[:team_member_id])
    end

    def set_breadcrumbs
      add_breadcrumb('Team Members', team_members_path, 'fas fa-users')
      add_breadcrumb(team_member.full_name, team_member_path(team_member))
      add_breadcrumb('Upload Activity Logs')
    end
  end
end
