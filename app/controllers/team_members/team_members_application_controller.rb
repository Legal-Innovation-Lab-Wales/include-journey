module TeamMembers
  # app/controllers/team_members/team_members_application_controller.rb
  class TeamMembersApplicationController < ApplicationController
    before_action :authenticate_team_member!
    before_action :require_approval

    protected

    def require_approval
      if current_team_member.present? && !current_team_member.approved?
        sign_out_and_redirect(current_team_member)
        session[:awaiting_approval_notice] = 'An admin needs to approve you before you can access the system!'
      end
    end

    def require_admin
      unless current_team_member.admin?
        respond_to do |format|
          format.html { redirect_to authenticated_team_member_root_path, error: 'You are not an admin!' }
          format.json { render json: '', status: :forbidden }
        end
      end
    end
  end
end