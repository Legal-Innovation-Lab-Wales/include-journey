# frozen_string_literal: true

module TeamMembers
  # app/controllers/team_members/diary_entries_controller.rb
  class DiaryEntriesController < TeamMembersApplicationController
    before_action :index_breadcrumbs, only: :index
    include Pagination

    # GET /diary_entries/:id
    def show
      @diary_entry = current_team_member.diary_entries
        .includes(:user)
        .find_by(id: params[:id])

      unless @diary_entry.present?
        redirect_back(
          fallback_location: diary_entries_path,
          alert: "That diary entry doesn't exist or you do not have permission to view it",
        )
        return
      end

      begin
        @diary_entry.log_view(current_team_member)
      rescue ActiveRecord::RecordInvalid
        # TODO: when would this happen?
        redirect_back(
          fallback_location: authenticated_team_member_root_path,
          alert: 'View log could not be created',
        )
        return
      end
  
      add_breadcrumb('Diary Entries', diary_entries_path, 'fas fa-book-open')
      add_breadcrumb('This Diary Entry')
      render 'show'
    end

    protected

    def resources
      resources = current_team_member.diary_entries
        .includes(:user, :diary_entry_view_logs)

      if diary_entry_params[:feeling].present? || diary_entry_params[:viewed].present?
        resources = resources.joins(:user)
          .where(diary_entry_search(''), query_terms({}))
      end
      resources.order(created_at: :desc)
    end

    def search
      current_team_member.diary_entries
        .includes(:user, :diary_entry_view_logs)
        .joins(:user)
        .where(diary_entry_search("(#{user_search})"), query_terms(wildcard_query))
        .order(created_at: :desc)
    end

    private

    def subheading_stats
      @created_in_last_week = @resources.created_in_last_week.size
      @created_in_last_month = @resources.created_in_last_month.size
    end

    def diary_entry_params
      params.permit(:page, :query, :limit, :viewed, :feeling)
    end

    def query_terms(query)
      if diary_entry_params[:feeling].present?
        query.merge(feeling: diary_entry_params[:feeling])
      else
        query
      end
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
