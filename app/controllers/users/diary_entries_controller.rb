# frozen_string_literal: true

module Users
  # app/controllers/users/diary_entries_controller.rb
  class DiaryEntriesController < UsersApplicationController
    before_action :set_breadcrumbs
    include Pagination

    # GET /diary_entries/new
    def new
      add_breadcrumb('New Entry', nil, 'fas fa-plus-circle')
      @diary_entry = DiaryEntry.new

      render 'new'
    end

    # POST /diary_entries
    def create
      @diary_entry = DiaryEntry.new(
        entry: diary_entry_params[:entry],
        feeling: diary_entry_params[:feeling],
        user: current_user,
      )

      if @diary_entry.save
        redirect_to(
          new_diary_entry_permission_path(@diary_entry),
          flash: {success: 'New diary entry added'},
        )
      else
        add_breadcrumb('New Entry', nil, 'fas fa-plus-circle')
        render 'new'
      end
    end

    protected

    def resources_per_page
      3
    end

    def resources
      current_user.diary_entries.order(created_at: :desc)
    end

    def search
      current_user.diary_entries
        .where('lower(entry) similar to lower(:query)', wildcard_query)
        .order(created_at: :desc)
    end

    def subheading_stats
      return unless @resources.present?

      @entries_in_last_30_days = @resources.where('created_at >= ?', 30.days.ago).count
      @days_since_last_entry = (Time.now.to_date - @resources.first.created_at.to_date).to_i
    end

    private

    def diary_entry_params
      params.require(:diary_entry).permit(:entry, :feeling)
    end

    def set_breadcrumbs
      path = if action_name != 'index' && resources.present?
        diary_entries_path
      else
        nil
      end
      add_breadcrumb('My Diary', path, 'fas fa-book')
    end
  end
end
