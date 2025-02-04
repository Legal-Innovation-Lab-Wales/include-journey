# frozen_string_literal: true

module TeamMembers
  # app/controllers/team_members/team_members_application_controller.rb
  class TeamMembersApplicationController < ApplicationController
    before_action :authenticate_team_member!
    before_action :require_approval
    before_action :require_not_suspended
    before_action :set_up_two_factor

    def terms
      add_breadcrumb('Terms', nil, 'fas fa-gavel')
      render 'pages/terms'
    end

    def privacy_notice
      add_breadcrumb('Privacy Notice', nil, 'fas fa-eye')
      render 'pages/privacy_notice'
    end

    def cookie_policy
      add_breadcrumb('Cookie Policy', nil, 'fas fa-cookie-bite')
      render 'pages/cookie_policy'
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

    def set_up_two_factor
      return if current_team_member.two_factor_enabled?

      flash.now[:alert] = 'You must have two-factor authentication enabled to have access!'
      render 'team_members/sessions/set_up_two_factor'
    end
  end
end
