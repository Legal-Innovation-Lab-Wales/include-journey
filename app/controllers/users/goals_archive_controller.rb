module Users
  # app/controllers/users/goals_archive_controller.rb
  class GoalsArchiveController < UsersApplicationController
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
  end
end
