module Users
  # app/controllers/users/users_application_controller.rb
  class UsersApplicationController < ApplicationController
    before_action :authenticate_user!

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

    # PUT /cancel_deletion
    def cancel_deletion
      current_user.update!(deleted_at: nil)

      redirect_back(
        fallback_location: authenticated_user_root_path,
        flash: {success: 'Your account will no longer be deleted.'},
      )
    end
  end
end
