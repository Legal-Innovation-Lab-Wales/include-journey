module Users
  # app/controllers/users/journey_controller.rb
  class JourneyController < UsersApplicationController
    # GET /journey
    def index
      @sessions_streak = current_user.sessions_streak
      @sessions_count = current_user.sessions_count
      @available_monthly_achievements = Achievement.this_month
                                                   .order(created_at: :asc)
      @achievements_count = 100

      render 'index'
    end
  end
end
