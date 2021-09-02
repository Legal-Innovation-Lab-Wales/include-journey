module Users
  # app/controllers/users/journey_controller.rb
  class JourneyController < UsersApplicationController
    # GET /journey
    def index
      @sessions_streak = current_user.sessions_streak
      @sessions_count = current_user.sessions_count
      @achievements_count = 100

      render 'index'
    end
  end
end
