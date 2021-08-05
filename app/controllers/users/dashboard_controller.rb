module Users
  # app/controllers/users/dashboard_controller.rb
  class DashboardController < UsersApplicationController
    def show
      @affirmation = Affirmation.find_by(scheduled_date: Date.today)
      @survey_path = Survey.available.count == 1 ? survey_path(Survey.first) : surveys_path

      render 'show'
    end
  end
end
