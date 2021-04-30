module Users
  # app/controllers/users/journal_entries_controller.rb
  class JournalEntriesController < UsersApplicationController
    include Pagination

    # GET /journal_entries/new
    def new
      @journal_entry = JournalEntry.new

      render 'new'
    end

    # POST /journal_entries
    def create
      if (@journal_entry = current_user.journal_entries.create!(journal_entry_params))
        redirect_to new_journal_entry_permission_path(@journal_entry), success: 'New journal entry added'
      else
        redirect_to authenticated_user_root_path, error: "Journal entry could not be created: #{@journal_entry.errors}"
      end
    end

    private

    def journal_entry_params
      params.require(:journal_entry).permit(:entry, :feeling)
    end

    def resources_per_page
      3
    end

    def resources
      @resources = current_user.journal_entries.order(created_at: :desc)
      set_overview_stats
    end

    def search
      current_user.journal_entries
                  .where('lower(entry) similar to lower(:query)', wildcard_query)
                  .order(created_at: :desc)
    end

    def set_overview_stats
      @entries_in_last_30_days = @resources.where('created_at >= ?', 30.days.ago).count
    end
  end
end
