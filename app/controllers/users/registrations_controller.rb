module Users
  # app/controllers/users/registrations_controller.rb
  class RegistrationsController < Devise::RegistrationsController
    before_action :set_breadcrumbs
    include Accessible
    skip_before_action :check_user, except: %i[new create]
    prepend_before_action :check_captcha, only: :create
    after_action :send_new_user_email, only: :create

    # DELETE /users
    def destroy
      current_user.update!(deleted_at: Time.now + 30.days)

      redirect_back(fallback_location: authenticated_user_root_path)
    end

    def set_breadcrumbs
      add_breadcrumb('My Profile', nil, 'fas fa-user-edit')
    end

    private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :mobile_number, :terms, :email, :password,
                                   :password_confirmation, :summary_panel, :address)
    end

    def check_captcha
      return if verify_recaptcha

      self.resource = resource_class.new user_params
      resource.validate
      respond_with_navigational(resource) {
        # delete default recaptcha error
        flash.delete(:recaptcha_error)
        # add custom recaptcha error
        flash[:error] = 'reCAPTCHA verification failed, please try again'
        flash.discard(:error)
        render :new
      }
    end


    def send_new_user_email
      return unless @user.created_at? || Time.now - User.second_to_last.created_at < 6.hours

      unapproved_count = User.where(approved: false).count
      TeamMember.admins.each do |admin|
        AdminMailer.new_team_member_email(current_user, admin, unapproved_count, true).deliver_now
      end
    end
  end
end
