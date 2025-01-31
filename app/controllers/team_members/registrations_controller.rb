module TeamMembers
  # app/controllers/team_members/registrations_controller.rb
  class RegistrationsController < Devise::RegistrationsController
    before_action :set_breadcrumbs
    include Accessible
    prepend_before_action :check_captcha, only: :create
    skip_before_action :check_user, except: %i[new create]
    before_action :set_up_two_factor, except: %i[new create]
    before_action :set_breadcrumbs

    after_action :send_new_team_member_email, only: :create

    private

    def send_new_team_member_email
      return unless @team_member.created_at? || Time.now - TeamMember.second_to_last.created_at < 6.hours

      unapproved_count = TeamMember.unapproved.count
      TeamMember.admins.each do |admin|
        AdminMailer.new_team_member_email(@team_member, admin, unapproved_count).deliver_later
      end
    end

    def set_breadcrumbs
      add_breadcrumb('Edit Profile', nil, 'fas fa-user-edit')
    end

    def team_member_params
      params.require(:team_member)
        .permit(:first_name, :last_name, :mobile_number, :terms, :email, :password, :password_confirmation)
    end

    def check_captcha
      return if verify_recaptcha

      self.resource = resource_class.new team_member_params
      resource.validate
      respond_with_navigational(resource) do
        # delete default recaptcha error
        flash.delete(:recaptcha_error)
        # add custom recaptcha error
        flash[:error] = 'reCAPTCHA verification failed, please try again'
        flash.discard(:error)
        render :new
      end
    end

    def set_up_two_factor
      return if current_team_member.two_factor_enabled?

      flash.now[:alert] = 'You must have two-factor authentication enabled to have access!'
      render 'team_members/sessions/set_up_two_factor'
    end
  end
end
