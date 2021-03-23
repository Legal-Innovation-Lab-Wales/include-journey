module TeamMembers
  # app/controllers/team_members/team_members_application_controller.rb
  class TeamMembersApplicationController < ApplicationController
    before_action :authenticate_team_member!
    before_action :require_approval

    def home
      render 'pages/main'
    end

    protected

    def require_approval
      return if current_team_member.approved?

      sign_out_and_redirect(current_team_member)
      session[:awaiting_approval_notice] = 'An admin needs to approve you before you can access the system!'
    end
  end
end
