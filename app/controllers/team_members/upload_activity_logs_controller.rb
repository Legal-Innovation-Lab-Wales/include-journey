module TeamMembers
  # app/controllers/team_members/upload_activity_logs_controller.rb
  class UploadActivityLogsController < ApplicationController
    before_action :team_member
    before_action :set_breadcrumbs
    include Pagination

    protected

    def resources
      @upload_activity_logs = @team_member.upload_activity_logs
      filter_params = upload_activity_logs_filter_params
      if filter_params[:activity_type].in?(%w[viewed modified downloaded approved rejected])
        @upload_activity_logs = @upload_activity_logs.includes(upload: %i[user upload_file]).joins(upload: %i[user upload_file])
                                                     .order(created_at: :desc).where(activity_type: filter_params[:activity_type])
      elsif filter_params[:activity_type].in?(%w[rejected])
        @upload_activity_logs = @upload_activity_logs.where(activity_type: filter_params[:activity_type])
      end

      @upload_activity_logs
    end

    def search
      resources.where(user_search, wildcard_query).or(resources.where(upload_file_name_search, wildcard_query))
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

    def upload_activity_logs_filter_params
      params.permit(:query, :activity_type, :team_member_id, :page, :id, :on, :limit)
    end

    def team_member
      @team_member = TeamMember.includes(:upload_activity_logs).find(params[:team_member_id])
    end

    def upload_file_name_search
      'lower(upload_files.name) similar to lower(:query)'
    end

    def set_breadcrumbs
      add_breadcrumb('Team Members', team_members_path, 'fas fa-users')
      add_breadcrumb(team_member.full_name, team_member_path(team_member), 'fas fa-user')
      add_breadcrumb('User File Activity Logs', nil, 'fas fa-clock')
    end
  end
end
