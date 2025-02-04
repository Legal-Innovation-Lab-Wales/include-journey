# frozen_string_literal: true

module Users
  # app/controllers/users/journey_controller.rb
  class JourneyController < UsersApplicationController
    # GET /journey
    def index
      add_breadcrumb('My Journey', nil, 'fas fa-road')
      @all_time_achievements = Achievement.includes(:user_achievements)
        .all_time
        .order(created_at: :asc)
      @available_monthly_achievements = Achievement.includes(:user_achievements)
        .this_month
        .order(created_at: :asc)

      render 'index'
    end
  end
end
