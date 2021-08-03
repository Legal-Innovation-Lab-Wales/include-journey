module Users
  # app/controllers/users/users_application_controller.rb
  class UsersApplicationController < ApplicationController
    before_action :authenticate_user!

    def terms
      render 'pages/terms'
    end

    def home
      render 'pages/main'
    end

    # PUT /cancel_deletion
    def cancel_deletion
      current_user.update!(deletion: nil)

      redirect_back(fallback_location: authenticated_user_root_path,
                    flash: { success: 'Your account will no longer be deleted.' })
    end
  end
end
