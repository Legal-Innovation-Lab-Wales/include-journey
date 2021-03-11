# frozen_string_literal: true

module Users
  # app/controllers/users/dashboard_controller.rb
  class DashboardController < UsersApplicationController
    def main
      render template: 'users/dashboard/main'
    end
  end
end
