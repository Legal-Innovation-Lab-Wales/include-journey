module TeamMembers
  # app/controllers/team_members/dashboard_controller.rb
  class DashboardController < TeamMembersApplicationController
    def show
      render 'show'
    end
  end
end
