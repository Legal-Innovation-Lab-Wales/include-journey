module Users
  # app/controllers/users/dashboard_controller.rb
  class DashboardController < UsersApplicationController
    def show
      @affirmation = Affirmation.first

      render 'show'
    end
  end
end
