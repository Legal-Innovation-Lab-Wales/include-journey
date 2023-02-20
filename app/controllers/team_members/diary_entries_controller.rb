module TeamMembers
  # app/controllers/team_members/diary_entries_controller.rb
  class DiaryEntriesController < TeamMembersApplicationController
    before_action :index_breadcrumbs, only: :index
    include Pagination

    # GET /diary_entries/:id
    def show
      diary_entry
      log_view

      add_breadcrumb('Diary Entries', diary_entries_path, 'fas fa-book-open')
      add_breadcrumb('This Diary Entry')
      render 'show'
    end

    protected

    def resources
      if diary_entry_params[:feeling].present? || diary_entry_params[:viewed].present?
        current_team_member.diary_entries.includes(:user, :diary_entry_view_logs)
                           .joins(:user)
                           .where(diary_entry_search(''), query_terms({}))
                           .order(created_at: :desc)
      else
        current_team_member.diary_entries.includes(:user, :diary_entry_view_logs)
                           .order(created_at: :desc)
      end
    end

    def search
      current_team_member.diary_entries.includes(:user, :diary_entry_view_logs)
                         .joins(:user)
                         .where(diary_entry_search("(#{user_search})"), query_terms(wildcard_query))
                         .order(created_at: :desc)
    end

    private

    def diary_entry
      @diary_entry = current_team_member.diary_entries.includes(:user).find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: diary_entries_path,
                    alert: "That diary entry doesn't exist or you do not have permission to view it")
    end

    def log_view
      view_log = current_team_member.diary_entry_view_logs.find_or_create_by!(diary_entry: @diary_entry)
      view_log.increment_view_count
      view_log.save!
    rescue ActiveRecord::RecordInvalid
      redirect_back(fallback_location: authenticated_team_member_root_path, alert: 'View log could not be created')
    end

    def subheading_stats
      @created_in_last_week = @resources.created_in_last_week.size
      @created_in_last_month = @resources.created_in_last_month.size
    end

    def diary_entry_params
      params.permit(:page, :query, :limit, :viewed, :feeling)
    end

    def query_terms(query)
      query = query.merge({ feeling: diary_entry_params[:feeling] }) if diary_entry_params[:feeling].present?
      query
    end

    def diary_entry_search(search)
      if diary_entry_params[:feeling].present?
        search += ' and ' if search.present?
        search += 'feeling=:feeling'
      end

      if diary_entry_params[:viewed].present?
        search += ' and ' if search.present?
        search += "diary_entry_view_logs.id is #{diary_entry_params[:viewed].to_i.zero? ? '' : 'not '}null"
      end

      search
    end

    def index_breadcrumbs
      add_breadcrumb('Diary Entries', nil, 'fas fa-book-open')
    end
  end
end
