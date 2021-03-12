# frozen_string_literal: true

module Users
  # app/controllers/users/journal_entries_controller.rb
  class JournalEntriesController < UsersApplicationController
    before_action :journal_entry_params, only: :create

    # POST /journal_entries/create
    def create
      if (@journal_entry = current_user.journal_entries.create!(journal_entry_params))
        respond_to do |format|
          format.html { redirect_to authenticated_user_root_path, alert: journal_entry_alert }
        end
      else
        render @journal_entry.errors, status: :unprocessable_entity
      end
    end

    private

    def journal_entry_alert
      'New journal entry created'
    end

    def journal_entry_params
      params.require(:journal_entry).permit(:entry, :feeling)
    end
  end
end