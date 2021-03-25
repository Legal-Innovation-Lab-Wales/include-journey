module TeamMembers
  # app/controllers/team_members/journal_entries_controller.rb
  class JournalEntriesController < PaginationController
    before_action :journal_entry, :view_log, only: :show

    # GET /journal_entries/:id
    def show
      render 'show'
    end

    protected

    def resources
      @resources = current_team_member.journal_entries.includes(:user, :journal_entry_view_logs)
                                      .order(created_at: :desc)
    end

    private

    def journal_entry
      @journal_entry = current_team_member.journal_entries.includes(:user).find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: journal_entries_path,
                    alert: "That journal entry doesn't exist or you do not have permission to view it")
    end

    def view_log
      return if current_team_member.journal_entry_view_logs.create!({ journal_entry: @journal_entry })

      redirect_back(fallback_location: authenticated_team_member_root_path, alert: 'View log could not be created')
    end
  end
end
