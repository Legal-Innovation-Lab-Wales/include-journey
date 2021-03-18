module TeamMembers
  # app/controllers/team_members/wba_self_view_logs_controller.rb
  class WbaSelfViewLogsController < ViewLogsController

    protected

    def resources
      @resources = @team_member.wba_self_view_logs.includes(:user, :wba_self)
    end

    def team_member
      @team_member = TeamMember.includes(:wba_self_view_logs).find(params[:team_member_id])
    end
  end
end
