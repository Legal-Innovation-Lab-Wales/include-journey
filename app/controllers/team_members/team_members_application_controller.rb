module TeamMembers
  # app/controllers/team_members/team_members_application_controller.rb
  class TeamMembersApplicationController < ApplicationController
    before_action :authenticate_team_member!
    before_action :require_approval
    before_action :require_not_suspended

    def terms
      render 'pages/terms'
    end

    def privacy_notice
      render 'pages/privacy_notice'
    end

    def home
      render 'pages/main'
    end

    protected

    def require_approval
      return if current_team_member.approved?

      sign_out_and_redirect(current_team_member)
      session[:sign_out_notice] = 'An admin needs to approve you before you can access the system.'
    end

    def require_not_suspended
      return unless current_team_member.suspended?

      sign_out_and_redirect(current_team_member)
      session[:sign_out_notice] =
        'Your account has been suspended. An admin will need to remove this suspension before you can access the system.'
    end
  end
end
