# frozen_string_literal: true

module Users
  # app/controllers/users/dashboard_controller.rb
  class DashboardController < UsersApplicationController
    before_action :wba_self_today, :wba_self, :wellbeing_metrics, :last_wba_self, :last_scores, :permissions_required, only: :main
    before_action :team_members, :second_to_last_wba_self, :last_wba_self_permissions, only: :main, if: -> { @permissions_required }

    def main
      render template: 'users/dashboard/main'
    end

    def last_score(wellbeing_metric_id)
      return 6 unless @last_scores.present?

      @last_scores.select { |score| score[:id] == wellbeing_metric_id }.first[:value]
    end

    def last_wba_self_permission(team_member_id)
      return true unless @last_wba_self.present?

      @last_wba_self_permissions.select { |team_member| team_member[:id] == team_member_id }.present?
    end

    helper_method :last_score, :last_wba_self_permission

    private

    def wba_self
      return if @wba_self_today

      @wba_self = WbaSelf.new
    end

    def wba_self_today
      @wba_self_today = current_user.wba_selves.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).present?
    end

    def last_scores
      return unless @last_wba_self.present?

      @last_scores = @last_wba_self.wba_self_scores.collect { |wba_self_score| { id: wba_self_score.wellbeing_metric_id, value: wba_self_score.value }}
    end

    def last_wba_self_permissions
      return unless @second_to_last_wba_self.present?

      @last_wba_self_permissions = @second_to_last_wba_self.wba_self_permissions.collect { |wba_self_permission| { id: wba_self_permission.team_member_id }}
    end

    def last_wba_self
      @last_wba_self = current_user.wba_selves.includes(:wba_self_scores).last
    end

    def second_to_last_wba_self
      @second_to_last_wba_self = current_user.wba_selves.includes(:wba_self_permissions).second_to_last
    end

    def permissions_required
      @permissions_required = current_user.wba_self_permissions_required?
    end

    def team_members
      @team_members = TeamMember.all
    end

    def wellbeing_metrics
      @wellbeing_metrics = WellbeingMetric.all
    end
  end
end
