module TeamMembers
  # app/controllers/team_members/journal_entry_view_logs_controller.rb
  class JournalEntryViewLogsController < ViewLogsController

    protected

    def count
      @count = @team_member.journal_entry_view_logs.count
    end

    def team_member
      @team_member = TeamMember.includes(:journal_entry_view_logs).find(params[:team_member_id])
    end

    def view_logs
      @view_logs = @team_member.journal_entry_view_logs.includes(:user, :journal_entry).offset(@offset).limit(VIEW_LOGS_PER_PAGE).order(created_at: :desc)
    end

    def view_log_path
      team_member_journal_entry_view_log_path(@team_member, 1)
    end
  end
end
