module Users
  # app/controllers/users/journal_entries_dashboard_controller.rb
  class JournalEntriesDashboardController < UsersApplicationController
    # GET /journal_entries/dashboard
    def show
      render 'show'
    end
  end
end
