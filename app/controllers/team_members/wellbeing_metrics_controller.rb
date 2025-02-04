# frozen_string_literal: true

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
      @wellbeing_metric = WellbeingMetric.find(ActiveRecord::Base.sanitize_sql_for_conditions(params[:id]))

      flash = if @wellbeing_metric.update(wellbeing_metric_params)
        {success: 'Wellbeing metric updated'}
      else
        {error: 'Wellbeing metric could not be updated. Please use only characters A-Z & 0-9'}
      end
      redirect_to(wellbeing_metrics_path, flash: flash)
    end

    private

    def wellbeing_metric_params
      params.require(:wellbeing_metric)
        .permit(:name, :category)
    end

    def set_breadcrumbs
      path = action_name == 'index' ? nil : wellbeing_metrics_path
      add_breadcrumb('Wellbeing Management', path, 'fas fa-tools')
    end
  end
end
