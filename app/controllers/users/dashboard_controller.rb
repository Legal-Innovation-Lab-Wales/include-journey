module Users
  # app/controllers/users/dashboard_controller.rb
  class DashboardController < UsersApplicationController
    def show
      render 'show'
    end

    private

    def latest_wba_self_path
      wba_self_today = current_user.wba_self_today
      wba_self_today.present? ? wba_self_path(wba_self_today) : new_wba_self_path
    end

    helper_method :latest_wba_self_path
  end
end
