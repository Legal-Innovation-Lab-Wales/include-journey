# frozen_string_literal: true

module Users
  # app/controllers/users/wba_selves_controller.rb
  class WbaSelvesController < UsersApplicationController
    before_action :wellbeing_metrics, :wba_selves_params, only: :create
    after_action :create_wba_self_scores, only: :create

    # POST /wba_selves/create
    def create
      if (@wba_self = current_user.wba_selves.create!({ user_id: current_user.id }))
        respond_to do |format|
          format.html { redirect_to authenticated_user_root_path, alert: wba_self_alert }
        end
      else
        render @wba_self.errors, status: :unprocessable_entity
      end
    end

    private

    def create_wba_self_scores
      @wellbeing_metrics.each do |metric|
        WbaSelfScore.create!({ wba_self_id: @wba_self.id, wellbeing_metric_id: metric.id,
                               value: wba_selves_params[metric_id(metric)] })
      end
    end

    def wellbeing_metrics
      @wellbeing_metrics = WellbeingMetric.all
    end

    def wba_self_alert
      'Wellbeing assessment successfully submit'
    end

    def wba_selves_params
      params.require(:wba_self).permit(@wellbeing_metrics.map { |metric| metric_id(metric) })
    end

    def metric_id(metric)
      "wellbeing_metric_#{metric.id}".to_sym
    end
  end
end
