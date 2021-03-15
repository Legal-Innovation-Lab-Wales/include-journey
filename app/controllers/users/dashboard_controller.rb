module Users
  # app/controllers/users/dashboard_controller.rb
  class DashboardController < UsersApplicationController
    def show
      render 'show'
    end
  end
end
