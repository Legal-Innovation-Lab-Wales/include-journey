module Users
  # app/controllers/users/wellbeing_services_controller.rb
  class WellbeingServicesController < UsersApplicationController
    # GET /wellbeing_services
    def index
      @wellbeing_services = WellbeingService.all

      render 'index'
    end
  end
end
