module TeamMembers
  # app/controllers/team_members/journal_entry_view_logs_controller.rb
  class JournalEntryViewLogsController < ViewLogsController
    protected

    def resources
      @resources =
        if @query.present?
          @team_member.journal_entry_view_logs.includes(:user, :journal_entry)
                      .joins(:user)
                      .where(user_search, wildcard_query)
        else
          @team_member.journal_entry_view_logs.includes(:user, :journal_entry)
        end
    end

    def team_member
      @team_member = TeamMember.includes(:journal_entry_view_logs).find(params[:team_member_id])
    end
  end
end
