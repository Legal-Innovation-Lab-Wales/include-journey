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
      @sort = pagination_params[:sort].present? ? pagination_params[:sort] : 'last_viewed_at'
      { "#{@sort == 'first_viewed_at' ? 'created_at' : 'updated_at'}": @direction }
    end

    private

    def team_member
      @team_member = TeamMember.includes(:user_profile_view_logs).find(params[:team_member_id])
    end
  end
end
