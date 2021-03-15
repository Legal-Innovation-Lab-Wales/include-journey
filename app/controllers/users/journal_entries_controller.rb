module Users
  # app/controllers/users/journal_entries_controller.rb
  class JournalEntriesController < UsersApplicationController
    before_action :new_journal_entry, only: :new
    before_action :journal_entry_params, only: :create

    # GET /journal_entries/new
    def new
      render 'new'
    end

    # POST /journal_entries/create
    def create
      if (@journal_entry = current_user.journal_entries.create!(journal_entry_params))
        redirect_to new_journal_entry_permission_path(@journal_entry)
      else
        redirect_to authenticated_user_root_path, alert: "Journal entry could not be created: #{@journal_entry.errors}"
      end
    end

    private

    def journal_entry_params
      params.require(:journal_entry).permit(:entry, :feeling)
    end

    def new_journal_entry
      @journal_entry = JournalEntry.new
    end
  end
end
