# frozen_string_literal: true

module Users
  # app/controllers/users/wba_selves_controller.rb
  class WbaSelvesController < UsersApplicationController
    before_action :wellbeing_metrics, :wba_selves_params, only: :create
    after_action :create_wba_self_scores, only: :create
    before_action :wba_self, :team_members, :wba_self_permissions_params, :validate_wba_self_permissions_params, :create_wba_self_permissions, only: :permissions

    # POST /wba_selves/create
    def create
      if (@wba_self = current_user.wba_selves.create!({ user_id: current_user.id }))
        respond_to do |format|
          format.html { redirect_to authenticated_user_root_path, alert: 'Wellbeing assessment successfully submit' }
        end
      else
        render @wba_self.errors, status: :unprocessable_entity
      end
    end

    # POST /wba_selves/:wba_self_id/permissions
    def permissions
      respond_to do |format|
        format.html { redirect_to authenticated_user_root_path, alert: 'Sharing permissions for team members successfully set' }
      end
    end

    private

    def create_wba_self_permissions
      @team_members.each do |team_member|
        next unless wba_self_permissions_params[team_member_id(team_member.id)] == '1'

        unless WbaSelfPermission.create!({ wba_self_id: @wba_self.id, team_member_id: team_member.id })
          puts("WBA Self Permission for user #{team_member.email} was not recorded for WBA Self #{@wba_self.id}")
        end
      end
    end

    def create_wba_self_scores
      @wellbeing_metrics.each do |metric|
        value = wba_selves_params[metric_id(metric.id)]

        unless WbaSelfScore.create!({ wba_self_id: @wba_self.id, wellbeing_metric_id: metric.id, value: value })
          puts("Wellbeing Metric #{metric.name} of value #{value} was not recorded for WBA Self #{@wba_self.id}")
        end
      end
    end

    def wellbeing_metrics
      @wellbeing_metrics = WellbeingMetric.all
    end

    def team_members
      @team_members = TeamMember.all
    end

    def wba_self
      @wba_self = WbaSelf.find(params[:wba_self_id])
    end

    def wba_self_permissions_params
      params.require(:wba_self).permit(@team_members.map { |team_member| team_member_id(team_member.id) })
    end

    def wba_selves_params
      params.require(:wba_self).permit(@wellbeing_metrics.map { |metric| metric_id(metric.id) })
    end

    def validate_wba_self_permissions_params
      return if @team_members.map { |team_member| wba_self_permissions_params[team_member_id(team_member.id)] }.include? '1'

      redirect_to authenticated_user_root_path, alert: 'You must select at least one team member!'
    end

    def metric_id(metric_id)
      "wellbeing_metric_#{metric_id}".to_sym
    end

    def team_member_id(team_member_id)
      "team_member_#{team_member_id}".to_sym
    end
  end
end
