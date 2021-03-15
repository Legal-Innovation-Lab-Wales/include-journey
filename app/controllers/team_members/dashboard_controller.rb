module TeamMembers
  # app/controllers/team_members/dashboard_controller.rb
  class DashboardController < TeamMembersApplicationController
    before_action :require_admin, only: :unapproved_team_members
    before_action :unapproved_team_members, :approved_team_members, :users, only: :show

    def show
      render 'show'
    end

    def unapproved_team_members
      @unapproved_team_members = TeamMember.all.where(approved: false).order(:id)
    end

    private

    def approved_team_members
      @approved_team_members = TeamMember.all.where(approved: true).order(:id)
    end

    def users
      @users = User.all.order(:id)
    end
  end
end
