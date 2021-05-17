module TeamMembers
  # app/controllers/team_members/journal_entries_controller.rb
  class JournalEntriesController < TeamMembersApplicationController
    include Pagination

    # GET /journal_entries/:id
    def show
      journal_entry
      log_view

      render 'show'
    end

    protected

    def resources
      if journal_entry_params[:feeling].present? || journal_entry_params[:viewed].present?
        current_team_member.journal_entries.includes(:user)
                           .joins(:user)
                           .where(journal_entry_search(''), query_terms({}))
                           .order(created_at: :desc)
      else
        current_team_member.journal_entries.includes(:user, :journal_entry_view_logs)
                           .order(created_at: :desc)
      end
    end

    def search
      current_team_member.journal_entries.includes(:user)
                         .joins(:user)
                         .where(journal_entry_search("(#{user_search})"), query_terms(wildcard_query))
                         .order(created_at: :desc)
    end

    private

    def journal_entry
      @journal_entry = current_team_member.journal_entries.includes(:user).find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: journal_entries_path,
                    alert: "That journal entry doesn't exist or you do not have permission to view it")
    end

    def log_view
      view_log = current_team_member.journal_entry_view_logs.find_or_create_by!(journal_entry: @journal_entry)
      view_log.increment_view_count
      view_log.save!
    rescue ActiveRecord::RecordInvalid
      redirect_back(fallback_location: authenticated_team_member_root_path, alert: 'View log could not be created')
    end

    def subheading_stats
      @created_in_last_week = @resources.created_in_last_week.size
      @created_in_last_month = @resources.created_in_last_month.size
    end

    def journal_entry_params
      params.permit(:page, :query, :limit, :viewed, :feeling)
    end

    def query_terms(query)
      query = query.merge({ feeling: journal_entry_params[:feeling] }) if journal_entry_params[:feeling].present?
      query
    end

    def journal_entry_search(search)
      if journal_entry_params[:feeling].present?
        search += ' and ' if search.present?
        search += 'feeling=:feeling'
      end

      if journal_entry_params[:viewed].present?
        search += ' and ' if search.present?
        search += "journal_entry_view_logs.id is #{journal_entry_params[:viewed].to_i.zero? ? '' : 'not '}null"
      end

      search
    end
  end
end
