module Users
  # app/controllers/users/wellbeing_services_controller.rb
  class WellbeingServicesController < UsersApplicationController
    before_action :set_breadcrumbs
    include Pagination

    def resources
      WellbeingService.all
    end

    def resources_per_page
      10
    end

    def set_breadcrumbs
      add_breadcrumb('My Support', nil, 'fas fa-info-circle')
    end

    def search
      WellbeingService.where('lower(name) similar to lower(:query)', wildcard_query)
                      .order(created_at: :desc)
    end

  end
end
