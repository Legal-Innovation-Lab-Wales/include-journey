module TeamMembers
  # app/controllers/team_members/dashboard_controller.rb
  class DashboardController < TeamMembersApplicationController
    before_action :admin, only: :show

    def show
      render 'show'
    end

    private

    def admin
      @admin = current_team_member.admin?
    end
  end
end
