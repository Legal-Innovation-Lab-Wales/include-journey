module TeamMembers
  # app/controllers/team_members/wba_team_members_controller.rb
  class WbaTeamMembersController < TeamMembersApplicationController
    before_action :require_admin, :set_team_member, :set_wba

    # GET /team_members/:team_member_id/wba/:wba_team_member_id
    def show
      redirect_to authenticated_team_member_root_path,
                  alert: "WBA for #{@wba.user.first_name} #{@wba.user.last_name} created by #{@team_member.first_name} #{@team_member.last_name} clicked!"
    end

    private

    def set_team_member
      @team_member = TeamMember.find(params[:team_member_id])
    end

    def set_wba
      @wba = WbaTeamMember.find(params[:wba_team_member_id])
    end
  end
end