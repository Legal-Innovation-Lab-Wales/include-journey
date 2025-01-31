module TeamMembers
  # app/controllers/team_members/admin_application_controller.rb
  class AdminApplicationController < TeamMembersApplicationController
    before_action :require_admin

    protected

    def require_admin
      return if current_team_member.admin?

      redirect_to(
        authenticated_team_member_root_path,
        flash: {error: 'You are not an admin'},
      )
    end
  end
end
