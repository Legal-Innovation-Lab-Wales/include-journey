module TeamMembers
  # app/controllers/team_members/upload_activity_logs_controller.rb
  class UploadActivityLogsController < ApplicationController
    before_action :team_member
    before_action :set_breadcrumbs
    include Pagination

    protected

    def resources
      @team_member.upload_activity_logs.includes(:upload)
                  .joins(:upload)
    end

    def search
      @team_member.upload_activity_logs.includes(:upload)
                  .joins(:upload)
                  .where(user_search, wildcard_query)
    end

    def subheading_stats
      @viewed_in_last_week = @resources.viewed_in_last_week.size
      @viewed_in_last_month = @resources.viewed_in_last_month.size
      @modified_in_last_week = @resources.modified_in_last_week.size
      @modified_in_last_month = @resources.modified_in_last_month.size
      @downloaded_in_last_week = @resources.downloaded_in_last_week.size
      @downloaded_in_last_month = @resources.downloaded_in_last_month.size
      @approved_in_last_week = @resources.approved_in_last_week.size
      @approved_in_last_month = @resources.approved_in_last_month.size
      @rejected_in_last_week = current_team_member.upload_activity_logs.rejected_in_last_week.size
      @rejected_in_last_month = current_team_member.upload_activity_logs.rejected_in_last_month.size
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
