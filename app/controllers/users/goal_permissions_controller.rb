# frozen_string_literal: true

module Users
  class GoalPermissionsController < PermissionsController
    before_action :team_members, :permissions, :can_add, :set_breadcrumbs

    def index
      @type = params[:type] || 'short'
      add_breadcrumb("Manage #{@type} term permissions", nil, 'fas fa-lock')
      @default_permission = false
    end

    def create
      @team_members.each do |team_member|
        is_declined = permissions_params["team_member_#{team_member.id}"].to_i.zero?
        permission = current_user.goal_permissions.where(team_member_id: team_member.id).first
        instance_obj = {}
        instance_obj[permissions_params[:type] == 'long' ? 'long_term' : 'short_term'] = !is_declined

        unless permission
          instance_obj['team_member_id'] = team_member.id
          current_user.goal_permissions.create!(instance_obj)
          next
        end
        permission.update!(instance_obj)
      end

      redirect_to(
        goals_path,
        flash: {success: 'Permissions Shared successfully'},
      )
    end

    def destroy
      permission = @model.find(params[:goal_permission_id])

      permission.destroy!

      redirect_to(
        goal_permissions_path(current_user),
        flash: {success: 'Permission successfully revoked'},
      )
    end

    protected

    def model
      @model = if params[:type] == 'long'
        current_user.goal_permissions.long_term
      else
        current_user.goal_permissions.short_term
      end
    end

    def permissions_params
      params.require(:goal_permission)
        .permit(:goal_type, :type, team_members.map { |t_m| "team_member_#{t_m.id}" })
    end

    def permissions
      model_collection = if params[:type] == 'long'
        @model.long_term
      else
        @model.short_term
      end

      @permissions = model_collection.collect do |permission|
        {
          id: permission.team_member_id,
          short_term: permission.short_term,
          long_term: permission.long_term,
        }
      end
    end

    def can_add
      @can_add = @permissions.length < @team_members.length
    end

    def team_members
      @team_members = current_user.team_members
        .order(:created_at)
    end

    def set_breadcrumbs
      add_breadcrumb('My Goals', goals_path, 'fas fa-tasks')
    end
  end
end
