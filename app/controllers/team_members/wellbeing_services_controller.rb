module TeamMembers
  # app/controllers/team_members/wellbeing_services_controller.rb
  class WellbeingServicesController < TeamMembersApplicationController
    before_action :wellbeing_metrics, only: %i[new edit]
    before_action :wellbeing_service, only: %i[show edit update destroy]

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
      render 'edit'
    end

    # POST /wellbeing_services
    def create
      puts 'Create new wellbeing service'
    end

    # GET /wellbeing_services/new
    def new
      @wellbeing_service = WellbeingService.new

      render 'new'
    end

    # PUT /wellbeing_services/:id
    def update
      puts 'Update a wellbeing service'
    end

    # DELETE /wellbeing_services/:id
    def destroy
      puts 'Delete a wellbeing service'
    end

    private

    def wellbeing_service
      @wellbeing_service = WellbeingService.includes(:wellbeing_metrics).find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to wellbeing_services_path, flash: { error: 'Wellbeing Service Not Found' }
    end

    def wellbeing_metrics
      @wellbeing_metrics = WellbeingMetric.all
    end
  end
end
