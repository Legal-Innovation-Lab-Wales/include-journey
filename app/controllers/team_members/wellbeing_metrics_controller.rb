module TeamMembers
  # app/controllers/team_members/wellbeing_metrics_controller.rb
  class WellbeingMetricsController < TeamMembersApplicationController
    before_action :wellbeing_metric, only: %i[edit update destroy]

    # GET /wellbeing_metrics
    def index
      @wellbeing_metrics = WellbeingMetric.includes(:team_member).all

      render 'index'
    end

    # GET /wellbeing_metrics/:id
    def show
      redirect_to wellbeing_metrics_path, notice: 'That view is not available'
    end

    # GET /wellbeing_metrics/:id/edit
    def edit
      render 'edit'
    end

    # POST /wellbeing_metrics
    def create
      puts 'Create new wellbeing metric...'
    end

    # GET /wellbeing_metrics/new
    def new
      @wellbeing_metric = WellbeingMetric.new

      render 'new'
    end

    # PUT /wellbeing_metrics/:id
    def update
      puts 'Update wellbeing metric...'
    end

    # DELETE /wellbeing_metrics/:id
    def destroy
      puts 'Delete wellbeing metric...'
    end

    private

    def wellbeing_metric
      @wellbeing_metric = WellbeingMetric.includes(:team_member, :wellbeing_services)
    rescue ActiveRecord::RecordNotFound
      redirect_to wellbeing_metrics_path, flash: { error: 'Wellbeing Metric Not Found' }
    end
  end
end
