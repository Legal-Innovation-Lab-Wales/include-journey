module TeamMembers
  # app/controllers/team_members/wba_team_members_controller.rb
  class WbaTeamMembersController < TeamMembersApplicationController
    before_action :wba_team_member, only: :show

    # GET /wba_team_member/:id
    def show
      redirect_back(fallback_location: authenticated_team_member_root_path,
                    alert: "WBA for #{@wba_team_member.user.full_name} created by #{@wba_team_member.team_member.full_name} clicked!")
    end

    private

    def wba_team_member
      @wba_team_member = WbaTeamMember.includes(:user, :team_member).find(params[:id])
    end
  end
end
