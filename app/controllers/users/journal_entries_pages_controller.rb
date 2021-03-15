module Users
  # app/controllers/users/journal_entries_controller.rb
  class JournalEntriesPagesController < UsersApplicationController
    before_action :page, :offset, :journal_entries, only: :index
    before_action :count, only: :index, if: -> { @journal_entries.present? }
    before_action :redirect, only: :index, unless: -> { @journal_entries.present? }

    LIMIT = 3

    # GET /journal_entries/page/:page_number
    def index
      render 'users/journal_entries/index'
    end

    def last_page
      @offset + LIMIT >= @count
    end

    helper_method :last_page

    private

    def count
      @count = current_user.journal_entries.count
    end

    def journal_entries
      @journal_entries = current_user.journal_entries.offset(@offset).limit(LIMIT).order(created_at: :desc)
    end

    def offset
      @offset = (@page - 1) * LIMIT
    end

    def page
      @page = params[:page_number].to_i
    end

    def redirect
      redirect_to dashboard_journal_entries_path, alert: 'No journal entries found'
    end
  end
end
