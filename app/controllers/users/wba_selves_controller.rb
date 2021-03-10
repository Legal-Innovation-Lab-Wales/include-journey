# frozen_string_literal: true

module Users
  # app/controllers/users/wba_selves_controller.rb
  class WbaSelvesController < UsersApplicationController
    before_action :wellbeing_metrics, :wba_selves_params, only: :create

    # POST /wba_selves/create
    def create
      if (@wba_self = current_user.wba_selves.create!({ user_id: current_user.id }))
        @wellbeing_metrics.each do |metric|
          value = wba_selves_params[metric_id(metric.id)]

          unless WbaSelfScore.create!({ wba_self_id: @wba_self.id, wellbeing_metric_id: metric.id, value: value })
            puts("Wellbeing Metric #{metric.name} of value #{value} was not recorded for WBA Self #{@wba_self.id}")
          end
        end

        respond_to do |format|
          format.html { redirect_to authenticated_user_root_path, alert: 'Success!' }
        end
      else
        render @wba_self.errors, status: :unprocessable_entity
      end
    end

    private

    def wellbeing_metrics
      @wellbeing_metrics = WellbeingMetric.all
    end

    def wba_selves_params
      params.require(:wba_self).permit(@wellbeing_metrics.map { |metric| metric_id(metric.id) })
    end

    def metric_id(metric_id)
      "wellbeing_metric_#{metric_id}".to_sym
    end
  end
end
