module Users
  # app/controllers/users/wellbeing_services_controller.rb
  class WellbeingServicesController < UsersApplicationController
    # GET /wellbeing_services
    def index
      add_breadcrumb('My Support', nil, 'fas fa-info-circle')
      @wellbeing_services = WellbeingService.all

      render 'index'
    end
  end
end
