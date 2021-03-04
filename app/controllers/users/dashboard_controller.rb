module Users
  # app/controllers/users/dashboard_controller.rb
  class DashboardController < ApplicationController
    def main
      render template: 'users/dashboard/main'
    end
  end
end