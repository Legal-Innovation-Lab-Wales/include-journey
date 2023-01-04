module Users
  # app/controllers/users/journal_entries_controller.rb
  class JournalEntriesController < UsersApplicationController
    before_action :set_breadcrumbs
    include Pagination

    # GET /journal_entries/new
    def new
      add_breadcrumb('New Entry', nil, 'fas fa-plus-circle')
      @journal_entry = JournalEntry.new

      render 'new'
    end

    # POST /journal_entries
    def create
      @journal_entry = JournalEntry.new(
        entry: journal_entry_params[:entry],
        feeling: journal_entry_params[:feeling],
        user: current_user
      )

      if @journal_entry.save
        redirect_to new_journal_entry_permission_path(@journal_entry), 
        flash: { success: 'New journal entry added' }
      else
        add_breadcrumb('New Entry', nil, 'fas fa-plus-circle')
        #flash[:error] = 'Please only use the characters A-Z & 0-9'
        render 'new'
      end

    end

    protected

    def resources_per_page
      3
    end

    def resources
      current_user.journal_entries.order(created_at: :desc)
    end

    def search
      current_user.journal_entries
                  .where('lower(entry) similar to lower(:query)', wildcard_query)
                  .order(created_at: :desc)
    end

    def subheading_stats
      return unless @resources.present?

      @entries_in_last_30_days = @resources.where('created_at >= ?', 30.days.ago).count
      @days_since_last_entry = (Time.now.to_date - @resources.first.created_at.to_date).to_i
    end

    private

    def journal_entry_params
      params.require(:journal_entry).permit(:entry, :feeling)
    end

    def set_breadcrumbs
      path = action_name == 'index' ? nil : journal_entries_path
      add_breadcrumb('My Journal', path, 'fas fa-book')
    end
  end
end
