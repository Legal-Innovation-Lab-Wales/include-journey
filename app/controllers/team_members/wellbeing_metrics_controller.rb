module TeamMembers
  # app/controllers/team_members/wellbeing_metrics_controller.rb
  class WellbeingMetricsController < TeamMembersApplicationController
    # GET /wellbeing_metrics
    before_action :set_breadcrumbs
    def index
      @wellbeing_metrics = WellbeingMetric.all

      render 'index'
    end

    # PUT /wellbeing_metrics/:id
    def update
      @wellbeing_metric = WellbeingMetric.find(params[:id])

      if @wellbeing_metric.update(wellbeing_metric_params)
        redirect_to wellbeing_metrics_path, flash: { success: 'Wellbeing metric updated' }
      else
        redirect_to wellbeing_metrics_path, flash: { error: 'Wellbeing metric could not be updated. Please use only characters A-Z & 0-9' }
      end
    end

    private

    def wellbeing_metric_params
      params.require(:wellbeing_metric).permit(:name, :category)
    end

    def set_breadcrumbs
      path = action_name == 'index' ? nil : wellbeing_metrics_path
      add_breadcrumb('Wellbeing Management', path, 'fas fa-tools')
    end
  end
end
