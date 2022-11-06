module Users
  # app/controllers/users/registrations_controller.rb
  class RegistrationsController < Devise::RegistrationsController
    before_action :set_breadcrumbs
    include Accessible
    skip_before_action :check_user, except: %i[new create]

    # DELETE /users
    def destroy
      current_user.update!(deleted_at: Time.now + 30.days)

      redirect_back(fallback_location: authenticated_user_root_path)
    end

    def set_breadcrumbs
      add_breadcrumb('My Profile', nil, 'fas fa-user-edit')
    end
  end
end
