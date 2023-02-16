module Users
  # app/controllers/users/wellbeing_services_controller.rb
  class WellbeingServicesController < UsersApplicationController
    before_action :set_breadcrumbs
    before_action :set_wellbeing_filters, :set_sort, only: :index
    include Pagination

    def resources
      @distances = false
      params[:postcode] = params[:postcode].present? ? params[:postcode].upcase : nil
      @wellbeing_services = WellbeingService.all
      @wellbeing_services = wellbeing_services_params[:type].present? ? @wellbeing_services.joins(:wellbeing_metrics).where('wellbeing_metrics.id': wellbeing_services_params[:type]) : @wellbeing_services
      process_postcode
      @wellbeing_services = @wellbeing_services.order({"#{@sort}": @direction }) if !@distances
      return @wellbeing_services
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
      params.permit(:sort, :radius, :postcode, :direction, :type, :query, :page)
    end

    private

    def process_postcode
      if params[:postcode].present? && params[:radius].present?
        @postcode_data = get_codes(params[:postcode].delete(' '))
        if @postcode_data['result']
          filter_by_radius
          @distances = true
        else
          @error = 'Could not retrieve postcode information, please include a complete postcode'
        end
      elsif !params[:postcode].present? && params[:radius].present?
        @error = 'Full postcode required with radius'
      elsif params[:postcode].present?
        @wellbeing_services = @wellbeing_services.where("replace(postcode, ' ', '') LIKE ?", "%#{params[:postcode].delete(' ')}%")
      end
    end

    def filter_by_radius
      result = @postcode_data['result']
      filtered_services = []
      @wellbeing_services.each do |service|
        dist = Geocoder::Calculations.distance_between([result['latitude'], result['longitude']], [service.latitude, service.longitude])
        if dist <= params[:radius].to_f
          service.distance = dist
          filtered_services.push(service)
        end
      end
      @wellbeing_services = filtered_services.sort_by{|element| element.values_at(@sort)}
      @wellbeing_services = @wellbeing_services.reverse if direction == 'desc'
    end

    def direction
      @direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
    end

    def set_sort
      @sort = %w[name, distance].include?(params[:sort]) ? params[:sort] : 'name'
    end

    def get_codes(code)
      RestClient.get("api.postcodes.io/postcodes/#{code}") { |response, request, result, &block|
        case response.code
          when 200
            JSON.parse response
          else
            JSON.parse response
        end
      }
    end
  end
end
