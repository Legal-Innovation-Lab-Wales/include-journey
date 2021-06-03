module Users
  # app/controllers/users/coming_soon_controller.rb
  class ComingSoonController < UsersApplicationController
    def coming_soon
      redirect_back(fallback_location: authenticated_user_root_path, notice: 'This functionality is coming soon.')
    end
  end
end
