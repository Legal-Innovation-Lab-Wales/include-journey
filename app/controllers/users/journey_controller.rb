module Users
  # app/controllers/users/journey_controller.rb
  class JourneyController < UsersApplicationController
    # GET /journey
    def index
      @all_time_achievements = Achievement.includes(:user_achievements)
                                          .all_time
                                          .order(created_at: :asc)
      @available_monthly_achievements = Achievement.includes(:user_achievements)
                                                   .this_month
                                                   .order(created_at: :asc)
      @bronze_achievements_count = current_user.bronze_achievements_count
      @silver_achievements_count = current_user.silver_achievements_count
      @gold_achievements_count = current_user.gold_achievements_count
      @achievements_count = @bronze_achievements_count + @silver_achievements_count + @gold_achievements_count

      render 'index'
    end
  end
end
