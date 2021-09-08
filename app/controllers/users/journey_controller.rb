module Users
  # app/controllers/users/journey_controller.rb
  class JourneyController < UsersApplicationController
    # GET /journey
    def index
      @sessions_streak = current_user.sessions_streak
      @sessions_count = current_user.sessions_count
      @all_time_achievements = Achievement.includes(:user_achievements)
                                          .all_time
                                          .order(created_at: :asc)
      @available_monthly_achievements = Achievement.includes(:user_achievements)
                                                   .this_month
                                                   .order(created_at: :asc)
      @achievements_count = current_user.achievements_count

      render 'index'
    end
  end
end
