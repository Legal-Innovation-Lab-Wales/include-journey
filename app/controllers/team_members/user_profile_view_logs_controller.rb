module TeamMembers
  # app/controllers/team_members/user_profile_view_logs_controller.rb
  class UserProfileViewLogsController < AdminApplicationController
    before_action :team_member
    before_action :set_breadcrumbs
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
      @sort = pagination_params[:sort].present? ? pagination_params[:sort] : 'last_viewed_at'
      { "#{@sort == 'first_viewed_at' ? 'created_at' : 'updated_at'}": @direction }
    end

    private

    def team_member
      @team_member = TeamMember.includes(:user_profile_view_logs).find(pagination_params[:team_member_id])
    end

    def set_breadcrumbs
      add_breadcrumb('Team Members', team_members_path, 'fas fa-users')
      add_breadcrumb(team_member.full_name, team_member_path(team_member), 'fas fa-user')
      add_breadcrumb('User Profile View Logs')
    end
  end
end
