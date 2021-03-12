# frozen_string_literal: true

module Users
  # app/controllers/users/wba_self_permission_controller.rb
  class WbaSelfPermissionsController < UsersApplicationController
    skip_before_action :wba_self_permissions_required
    before_action :wba_self, :verify_user, :verify_permissions_needed, :team_members
    before_action :second_to_last_wba_self, only: :new
    before_action :last_wba_self_permissions, only: :new, if: -> { @second_to_last_wba_self.present? }
    before_action :wba_self_permissions_params, :validate_permissions_params, :create_wba_self_permissions, only: :create

    # GET /wba_selves/:wba_self_id/wba_self_permissions/new
    def new
      render 'new'
    end

    # POST /wba_selves/:wba_self_id/wba_self_permissions/create
    def create
      respond_to do |format|
        format.html { redirect_to authenticated_user_root_path, alert: 'Sharing permissions for team members successfully set' }
      end
    end

    protected

    def last_wba_self_permission(team_member_id)
      return true unless @second_to_last_wba_self.present?

      @last_wba_self_permissions.select { |team_member| team_member[:id] == team_member_id }.present?
    end

    helper_method :last_wba_self_permission

    private

    def create_wba_self_permissions
      @team_members.each do |team_member|
        next unless wba_self_permissions_params["team_member_#{team_member.id}".to_sym] == '1'

        WbaSelfPermission.create!({ wba_self_id: @wba_self.id, team_member_id: team_member.id })
      end
    end

    def last_wba_self_permissions
      @last_wba_self_permissions = @second_to_last_wba_self.wba_self_permissions.collect { |wba_self_permission| { id: wba_self_permission.team_member_id }}
    end

    def second_to_last_wba_self
      @second_to_last_wba_self = current_user.wba_selves.includes(:wba_self_permissions).second_to_last
    end

    def team_members
      @team_members = TeamMember.all
    end

    def wba_self
      @wba_self = WbaSelf.find(params[:wba_self_id])
    end

    def wba_self_permissions_params
      params.require(:wba_self).permit(@team_members.map { |team_member| "team_member_#{team_member.id}".to_sym })
    end

    def validate_permissions_params
      return if @team_members.map { |team_member| wba_self_permissions_params["team_member_#{team_member.id}".to_sym] }.include? '1'

      redirect_to new_wba_self_wba_self_permission_path(@wba_self), alert: 'You must select at least one team member!'
    end

    def verify_user
      return if @wba_self.user == current_user

      redirect_to authenticated_user_root_path, alert: 'That wellbeing assessment does not belong to you'
    end

    def verify_permissions_needed
      return unless @wba_self.wba_self_permissions.present?

      # redirect_to wba_selves_path(@wba_self), alert: 'Permissions have already been set for that wellbeing assessment'
      redirect_to authenticated_user_root_path, alert: 'Permissions have already been set for that wellbeing assessment'
    end
  end
end
