# frozen_string_literal: true

module Users
  # app/controllers/users/journal_entries_controller.rb
  class JournalEntriesController < UsersApplicationController
    before_action :journal_entry, :journal_entries, only: :new
    before_action :journal_entry_params, only: :create

    # GET /journal_entries/new
    def new
      render 'new'
    end

    # POST /journal_entries/create
    def create
      if (@journal_entry = current_user.journal_entries.create!(journal_entry_params))
        respond_to do |format|
          format.html { redirect_to authenticated_user_root_path, alert: 'New journal entry created' }
        end
      else
        render @journal_entry.errors, status: :unprocessable_entity
      end
    end

    private

    def journal_entry
      @journal_entry = JournalEntry.new
    end

    def journal_entries
      @journal_entries = current_user.journal_entries.order(created_at: :desc)
    end

    def journal_entry_params
      params.require(:journal_entry).permit(:entry, :feeling)
    end
  end
end
