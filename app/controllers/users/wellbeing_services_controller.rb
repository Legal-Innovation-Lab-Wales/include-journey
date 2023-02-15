module Users
  # app/controllers/users/wellbeing_services_controller.rb
  class WellbeingServicesController < UsersApplicationController
    before_action :set_breadcrumbs
    before_action :set_wellbeing_filters, only: :index
    include Pagination

    def resources
      @wellbeing_services = WellbeingService.all
      @wellbeing_services = wellbeing_services_params[:type].present? ? @wellbeing_services.joins(:wellbeing_metrics).where('wellbeing_metrics.id': wellbeing_services_params[:type]) : @wellbeing_services
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

    def set_wellbeing_filters
      @service_type_list = WellbeingMetric.all
    end

    def wellbeing_services_params
      params.permit(:sort, :direction, :type, :query, :page)
    end
  end
end
