module TeamMembers
  # app/controllers/team_members/wellbeing_services_controller.rb
  class WellbeingServicesController < TeamMembersApplicationController
    before_action :wellbeing_metrics, except: %i[show index destroy]
    before_action :wellbeing_service, only: %i[show edit update destroy]
    before_action :set_breadcrumbs
    after_action :metrics_services, only: %i[update]

    # GET /wellbeing_services
    def index
      @wellbeing_services = WellbeingService.includes(:team_member, :wellbeing_metrics).all

      render 'index'
    end

    # GET /wellbeing_services/:id
    def show
      redirect_to wellbeing_services_path, notice: 'That view is not available'
    end

    # GET /wellbeing_services/:id/edit
    def edit
      add_breadcrumb('Edit Wellbeing Service', nil, 'fas fa-edit')
      render 'edit'
    end

    # POST /wellbeing_services
    def create
      @wellbeing_service = WellbeingService.new(
        name: wellbeing_service_params[:name],
        description: wellbeing_service_params[:description],
        website: wellbeing_service_params[:website],
        contact_number: wellbeing_service_params[:contact_number],
        recommend: wellbeing_service_params[:recommend],
        team_member: current_team_member,
        postcode: wellbeing_service_params[:postcode],
        address: wellbeing_service_params[:address]
      )
     
      if @wellbeing_service.save
        metrics_services
        redirect_to wellbeing_services_path, flash: { success: 'New wellbeing service added' }
      else
        add_breadcrumb('New Wellbeing Service', nil, 'fas fa-plus-circle')
        render 'new'
      end
    end

    # GET /wellbeing_services/new
    def new
      add_breadcrumb('New Wellbeing Service', nil, 'fas fa-plus-circle')
      @wellbeing_service = WellbeingService.new

      render 'new'
    end

    # PUT /wellbeing_services/:id
    def update
      if @wellbeing_service.update(name: wellbeing_service_params[:name],
                                   description: wellbeing_service_params[:description],
                                   website: wellbeing_service_params[:website],
                                   contact_number: wellbeing_service_params[:contact_number],
                                   recommend: wellbeing_service_params[:recommend],
                                   postcode: wellbeing_service_params[:postcode],
                                   address: wellbeing_service_params[:address])
        redirect_to wellbeing_services_path, flash: { success: 'Wellbeing service updated' }
      else
        add_breadcrumb('Edit Wellbeing Service', nil, 'fas fa-edit')
        render 'edit'
      end
    end

    # DELETE /wellbeing_services/:id
    def destroy
      @wellbeing_service.metrics_services.destroy_all

      if @wellbeing_service.destroy!
        redirect_to wellbeing_services_path, notice: 'Wellbeing service has been deleted'
      else
        redirect_to wellbeing_services_path, flash: { error: 'Wellbeing service could not be deleted' }
      end
    end

    private

    def metrics_services
      @wellbeing_metrics.each do |metric|
        param = wellbeing_service_params["wellbeing_metric_#{metric.id}"].to_i

        param.zero? ? @wellbeing_service.unlink_metric(metric.id) : @wellbeing_service.link_metric(metric.id)
      end
    end

    def wellbeing_service
      @wellbeing_service = WellbeingService.includes(:wellbeing_metrics).find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to wellbeing_services_path, flash: { error: 'Wellbeing Service Not Found' }
    end

    def wellbeing_metrics
      @wellbeing_metrics = WellbeingMetric.all
    end

    def wellbeing_service_params
      params.require(:wellbeing_service).permit(:name, :description, :website, :contact_number, :recommend, :postcode, :address,
                                                @wellbeing_metrics.map { |metric| "wellbeing_metric_#{metric.id}" })
    end

    def set_breadcrumbs
      path = action_name == 'index' ? nil : wellbeing_services_path
      add_breadcrumb('Wellbeing Management', path, 'fas fa-tools')
    end
  end
end
