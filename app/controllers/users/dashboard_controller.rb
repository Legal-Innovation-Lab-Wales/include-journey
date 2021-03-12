# frozen_string_literal: true

module Users
  # app/controllers/users/dashboard_controller.rb
  class DashboardController < UsersApplicationController
    def show
      render 'show'
    end

    private

    def latest_wba_self_path
      wba_self_today = current_user.wba_selves.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).order(:id)
      wba_self_today.empty? ? new_wba_self_path : wba_self_path(wba_self_today.last)
    end

    helper_method :latest_wba_self_path
  end
end
