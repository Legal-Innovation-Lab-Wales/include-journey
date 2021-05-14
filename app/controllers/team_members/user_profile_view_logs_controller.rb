module TeamMembers
  # app/controllers/team_members/user_profile_view_logs_controller.rb
  class UserProfileViewLogsController < AdminApplicationController
    before_action :team_member
    include Pagination

    protected

    def resources
      @team_member.user_profile_view_logs
                  .includes(:user)
                  .order(sort)
    end

    def search
      @team_member.user_profile_view_logs
                  .includes(:user)
                  .joins(:user)
                  .where(user_search, wildcard_query)
                  .order(sort)
    end

    def subheading_stats
      @viewed_in_last_week = @resources.viewed_in_last_week.size
      @viewed_in_last_month = @resources.viewed_in_last_month.size
    end

    def sort
      sort_param = user_profile_view_logs_params[:sort]

      if %w[created_at_asc created_at_desc viewed_at_asc viewed_at_desc].include?(sort_param)
        sort_param = sort_param.split('_')
        { "#{sort_param[0..1].join('_') == 'viewed_at' ? 'updated_at' : 'created_at'}": sort_param[2] }
      else
        { 'created_at': :desc }
      end
    end

    private

    def team_member
      @team_member = TeamMember.includes(:user_profile_view_logs).find(params[:team_member_id])
    end

    def user_profile_view_logs_params
      params.permit(:page, :query, :limit, :sort)
    end
  end
end
