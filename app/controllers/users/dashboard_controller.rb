# frozen_string_literal: true

module Users
  # app/controllers/users/dashboard_controller.rb
  class DashboardController < UsersApplicationController
    before_action :wba_self, :wellbeing_metrics, :last_scores, only: :main

    def main
      render template: 'users/dashboard/main'
    end

    def last_score(wellbeing_metric_id)
      return 6 unless @last_scores.present?

      @last_scores.filter { |score| score[:id] == wellbeing_metric_id }.first[:value]
    end

    helper_method :last_score

    private

    def wba_self
      @wba_self = WbaSelf.new
    end

    def last_scores
      last_wba_self = current_user.wba_selves.includes(:wba_self_scores).last

      return unless last_wba_self.present?

      @last_scores = last_wba_self.wba_self_scores.collect { |wba_self_score| { id: wba_self_score.wellbeing_metric_id, value: wba_self_score.value }}
    end

    def wellbeing_metrics
      @wellbeing_metrics = WellbeingMetric.all
    end
  end
end
