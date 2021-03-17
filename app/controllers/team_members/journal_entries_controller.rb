module TeamMembers
  # app/controllers/team_members/journal_entries_controller.rb
  class JournalEntriesController < TeamMembersApplicationController
    before_action :page, :offset, :journal_entries, only: :page_index
    before_action :count, :last_page, :journal_entry_view_logs, only: :page_index, if: -> { @journal_entries.present? }
    before_action :redirect, only: :page_index, unless: -> { @journal_entries.present? }

    before_action :journal_entry, :add_view_log, only: :show

    LIMIT = 5

    # GET /journal_entries
    def index
      redirect_to pages_journal_entries_path(1)
    end

    # GET /journal_entries/page/:page_number
    def page_index
      render 'index'
    end

    # GET /journal_entries/:id
    def show
      render 'show'
    end

    private

    def add_view_log
      return if JournalEntryViewLog.create!({ team_member: current_team_member, journal_entry: @journal_entry })

      redirect_back(fallback_location: authenticated_team_member_root_path, alert: 'View log could not be created')
    end

    def count
      @count = current_team_member.journal_entries.count
    end

    def journal_entries
      @journal_entries = current_team_member.journal_entries.includes(:user).offset(@offset).limit(LIMIT).order(created_at: :desc)
    end

    def journal_entry
      @journal_entry = current_team_member.journal_entries.includes(:user).find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: journal_entries_path, alert: 'That journal entry doesn\'t exist or you do not have permission to view it')
    end

    def journal_entry_view_logs
      @journal_entry_view_logs = current_team_member.journal_entry_view_logs.collect { |view_log| { id: view_log.journal_entry_id } }
    end

    def last_page
      @last_page = @offset + LIMIT >= @count
    end

    def offset
      @offset = (@page - 1) * LIMIT
    end

    def page
      @page = params[:page_number].to_i
    end

    def redirect
      redirect_to authenticated_team_member_root_path, alert: 'No journal entries found'
    end
  end
end
