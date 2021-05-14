module TeamMembers
  # app/controllers/team_members/team_members_application_controller.rb
  class TeamMembersApplicationController < ApplicationController
    before_action :authenticate_team_member!
    before_action :require_approval
    before_action :require_unpaused

    def terms
      render 'pages/terms'
    end

    def home
      render 'pages/main'
    end

    def pyramid
      render 'pages/pyramid'
    end

    protected

    def require_approval
      return if current_team_member.approved?

      sign_out_and_redirect(current_team_member)
      session[:sign_out_notice] = 'An admin needs to approve you before you can access the system.'
    end

    def require_unpaused
      return unless current_team_member.paused?

      sign_out_and_redirect(current_team_member)
      session[:sign_out_notice] =
        'Your account has been paused. An admin will need to unpause your account before you can access the system.'
    end
  end
end
