module TeamMembers
  # app/controllers/team_members/diary_entry_view_logs_controller.rb
  class DiaryEntryViewLogsController < AdminApplicationController
    before_action :team_member
    before_action :set_breadcrumbs
    include Pagination

    protected

    def resources
      @team_member.diary_entry_view_logs.includes(:user, :diary_entry)
                  .joins(:diary_entry)
                  .order(sort)
    end

    def search
      @team_member.diary_entry_view_logs.includes(:user, :diary_entry)
                  .joins(:diary_entry)
                  .where(user_search, wildcard_query)
                  .order(sort)
    end

    def subheading_stats
      @viewed_in_last_week = @resources.viewed_in_last_week.size
      @viewed_in_last_month = @resources.viewed_in_last_month.size
    end

    def sort
      @sort = pagination_params[:sort].present? ? pagination_params[:sort] : 'last_viewed_at'
      { "#{sort_param}": @direction }
    end

    private

    def sort_param
      case @sort
      when 'published_at'
        'diary_entries.created_at'
      when 'first_viewed_at'
        'diary_entry_view_logs.created_at'
      else
        'diary_entry_view_logs.updated_at'
      end
    end

    def team_member
      @team_member = TeamMember.includes(:diary_entry_view_logs).find(params[:team_member_id])
    end

    def set_breadcrumbs
      add_breadcrumb('Team Members', team_members_path, 'fas fa-users')
      add_breadcrumb(team_member.full_name, team_member_path(team_member), 'fas fa-user')
      add_breadcrumb('Diary Entry View Logs')
    end
  end
end
