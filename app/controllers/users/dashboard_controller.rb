# frozen_string_literal: true

module Users
  # app/controllers/users/dashboard_controller.rb
  class DashboardController < UsersApplicationController
    before_action :crisis_event, only: :main

    def main
      render template: 'users/dashboard/main'
    end

    private

    def crisis_event
      @crisis_event = CrisisEvent.new
    end
  end
end
