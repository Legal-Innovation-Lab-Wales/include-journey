# frozen_string_literal: true

module Users
  # app/controllers/users/pages_controller.rb
  class PagesController < UsersApplicationController
    def main
      redirect_to authenticated_user_dashboard_path
    end
  end
end
