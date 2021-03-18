module TeamMembers
  # app/controllers/team_members/wba_team_members_controller.rb
  class WbaTeamMembersController < TeamMembersApplicationController
    before_action :require_admin, :team_member, :wba

    # GET /team_members/:team_member_id/wba/:wba_team_member_id
    def show
      redirect_to team_member_path(@team_member),
                  alert: "WBA for #{@wba.user.first_name} #{@wba.user.last_name} created by #{@team_member.first_name} #{@team_member.last_name} clicked!"
    end

    private

    def team_member
      @team_member = TeamMember.find(params[:team_member_id])
    end

    def wba
      @wba = WbaTeamMember.find(params[:id])
    end
  end
end
