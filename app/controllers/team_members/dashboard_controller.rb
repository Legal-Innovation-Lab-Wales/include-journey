module TeamMembers
  # app/controllers/team_members/dashboard_controller.rb
  class DashboardController < ApplicationController
    def main
      render template: 'team_members/dashboard/main'
    end
  end
end