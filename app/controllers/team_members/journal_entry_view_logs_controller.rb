module TeamMembers
  # app/controllers/team_members/journal_entry_view_logs_controller.rb
  class JournalEntryViewLogsController < ViewLogsController
    before_action :query,:search, :limit_resources, :redirect, only: :index

    protected

    def resources
      @resources = @team_member.journal_entry_view_logs.includes(:user, :journal_entry)
    end

    def team_member
      @team_member = TeamMember.includes(:journal_entry_view_logs).find(params[:team_member_id])
    end

    private

    def search
      return unless @query.present?

      @resources = @team_member.journal_entry_view_logs.includes(:user, :journal_entry).joins(:user)
                               .where('lower(users.first_name) like lower(?) or lower(users.last_name) like lower(?)',
                                      "%#{@query}%", "%#{@query}%")
    end

    def query
      @query = query_params[:query]
    end

    def query_params
      params.permit(:query, :page)
    end


  end
end
