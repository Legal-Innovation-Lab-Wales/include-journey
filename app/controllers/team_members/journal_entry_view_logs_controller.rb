module TeamMembers
  # app/controllers/team_members/journal_entry_view_logs_controller.rb
  class JournalEntryViewLogsController < ViewLogsController

    protected

    def resources
      @resources = @team_member.journal_entry_view_logs.includes(:user, :journal_entry)
    end

    def team_member
      @team_member = TeamMember.includes(:journal_entry_view_logs).find(params[:id])
    end
  end
end
