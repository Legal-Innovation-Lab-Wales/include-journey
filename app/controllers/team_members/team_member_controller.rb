module TeamMembers
  # app/controllers/team_members/team_member_controller.rb
  class TeamMemberController < ApplicationController
    before_action :authenticate_team_member!
    before_action :require_approval

    protected

    def require_approval
      if current_team_member.present? && !current_team_member.approved?
        sign_out_and_redirect(current_team_member)
        session[:awaiting_approval_notice] = 'An admin needs to approve you before you can access the system!'
      end
    end
  end
end