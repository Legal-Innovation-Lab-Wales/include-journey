module Users
  # app/controllers/users/registrations_controller.rb
  class RegistrationsController < Devise::RegistrationsController
    before_action :set_breadcrumbs
    include Accessible
    skip_before_action :check_user, except: %i[new create]
    prepend_before_action :check_captcha, only: :create

    private
    def check_captcha
      unless verify_recaptcha
        self.resource = resource_class.new user_params
        resource.validate
        respond_with_navigational(resource) {
          # delete default recaptcha error
          flash.delete(:recaptcha_error)
          # add custom recaptcha error
          flash[:error] = "reCAPTCHA verification failed, please try again";
          flash.discard(:error)
          render :new 
        }
      end
    end

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
      params.require(:user).permit(:first_name, :last_name, :mobile_number, :released_at, :email, :password, :password_confirmation)
    end
  end
end
