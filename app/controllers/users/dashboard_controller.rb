module Users
  # app/controllers/users/dashboard_controller.rb
  class DashboardController < UsersApplicationController
    def show
      @affirmation = Affirmation.find_by(scheduled_date: Date.today)

      render 'show'
    end
  end
end
