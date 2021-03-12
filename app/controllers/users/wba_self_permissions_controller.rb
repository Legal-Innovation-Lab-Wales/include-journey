# frozen_string_literal: true

module Users
  # app/controllers/users/wba_self_permission_controller.rb
  class WbaSelfPermissionsController < UsersApplicationController
    before_action :wba_self, :team_members, :wba_self_permissions_params, :validate_permissions_params, :create_wba_self_permissions, only: :create

    # POST /wba_selves/:wba_self_id/wba_self_permissions/create
    def create
      respond_to do |format|
        format.html { redirect_to authenticated_user_root_path, alert: wba_self_permissions_alert }
      end
    end

    private

    def create_wba_self_permissions
      @team_members.each do |team_member|
        next unless wba_self_permissions_params[team_member_id(team_member)] == '1'

        WbaSelfPermission.create!({ wba_self_id: @wba_self.id, team_member_id: team_member.id })
      end
    end

    def team_members
      @team_members = TeamMember.all
    end

    def team_member_id(team_member)
      "team_member_#{team_member.id}".to_sym
    end

    def wba_self
      @wba_self = WbaSelf.find(params[:wba_self_id])
    end

    def wba_self_permissions_alert
      'Sharing permissions for team members successfully set'
    end

    def wba_self_permissions_params
      params.require(:wba_self).permit(@team_members.map { |team_member| team_member_id(team_member) })
    end

    def validate_permissions_params
      if @team_members.map { |team_member| wba_self_permissions_params[team_member_id(team_member)] }.include? '1'
        return
      end

      redirect_to authenticated_user_root_path, alert: 'You must select at least one team member!'
    end
  end
end
