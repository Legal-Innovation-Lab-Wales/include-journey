module Users
  # app/controllers/users/registrations_controller.rb
  class RegistrationsController < Devise::RegistrationsController
    include Accessible
    skip_before_action :check_user, except: %i[new create]

    # DELETE /users
    def destroy
      current_user.update!(deletion: Time.now + 30.days)

      redirect_back(fallback_location: authenticated_user_root_path)
    end
  end
end
