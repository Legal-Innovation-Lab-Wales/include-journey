module TeamMembers
  # app/controllers/team_members/dashboard_controller.rb
  class DashboardController < TeamMembersApplicationController
    before_action :require_admin, only: :unapproved_team_members
    before_action :unapproved_team_members, :approved_team_members, :users, only: :main

    def main
      render template: 'team_members/dashboard/main'
    end

    private

    def unapproved_team_members
      @unapproved_team_members = TeamMember.all.where(approved: false).order(:id)
    end

    def approved_team_members
      @approved_team_members = TeamMember.all.where(approved: true).order(:id)
    end

    def users
      @users = User.all.order(:id)
    end
  end
end