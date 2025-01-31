module TeamMembers
  # app/controllers/team_members/sessions_controller.rb
  class SessionsController < Devise::SessionsController
    include Accessible
    include AuthenticateWithOtpTwoFactor
    skip_before_action :check_user, only: :destroy

    prepend_before_action(
      :authenticate_with_otp_two_factor,
      if: -> { action_name == 'create' && otp_two_factor_enabled? },
    )

    protect_from_forgery with: :exception, prepend: true, except: :destroy

    # before_action :configure_sign_in_params, only: [:create]

    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    # def create
    #   super
    # end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_in, keys: [:otp_attempt])
    end
  end
end
