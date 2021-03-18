module TeamMembers
  # app/controllers/team_members/journal_entries_controller.rb
  class JournalEntriesController < PaginationController
    before_action :journal_entry_view_logs, only: :index
    before_action :journal_entry, :view_log, only: :show

    # GET /journal_entries/:id
    def show
      render 'show'
    end

    protected

    def resources
      @resources = CrisisEvent.closed.includes(:user, :crisis_type)
    end

    private

    def journal_entry
      @journal_entry = current_team_member.journal_entries.includes(:user).find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: journal_entries_path,
                    alert: "That journal entry doesn't exist or you do not have permission to view it")
    end

    def journal_entry_view_logs
      @journal_entry_view_logs = current_team_member.journal_entry_view_logs.collect { |view_log| { id: view_log.journal_entry_id } }
    end

    def view_log
      return if current_team_member.journal_entry_view_logs.create!({ journal_entry: @journal_entry })

      redirect_back(fallback_location: authenticated_team_member_root_path, alert: 'View log could not be created')
    end
  end
end
