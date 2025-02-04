# frozen_string_literal: true

module Users
  # app/controllers/users/goals_archive_controller.rb
  class GoalsArchiveController < UsersApplicationController
    before_action :set_breadcrumbs
    include Pagination

    protected

    def resources
      current_user.goals
        .includes(:goal_type)
        .archived
        .order(:created_at)
    end

    def search
      current_user.goals
        .includes(:goal_type)
        .where('lower(goal) similar to lower(:query)', wildcard_query)
        .order(updated_at: :desc)
    end

    private

    def set_breadcrumbs
      add_breadcrumb('My Goals', goals_path, 'fas fa-tasks')
      path = action_name == 'index' ? nil : goals_archive_path
      add_breadcrumb('Archive', path, 'fas fa-archive')
    end
  end
end
