module Users
  # app/controllers/users/wba_self_permission_controller.rb
  class PermissionsController < UsersApplicationController
    before_action :team_members, :model, :verify_user, :verify_permissions_needed
    before_action :permissions_params, :validate_params, only: :create
    before_action :second_to_last, only: :new

    def new
      raise 'Subclass has not overridden permissions new function'
    end

    def create
      raise 'Subclass has not overridden permissions create function'
    end

    protected

    def last_permission(team_member_id)
      return true unless @last_permissions.present?

      @last_permissions.select { |team_member| team_member[:id] == team_member_id }.present?
    end

    helper_method :last_permission


    def last_permissions
      return unless @second_to_last.present?

      @last_permissions = @second_to_last.permissions.collect { |permission| { id: permission.team_member_id } }
    end

    def model
      raise 'Subclass has not overridden model instance variable'
    end

    def permissions_params
      params.require(@model.class.model_name.singular).permit(@team_members.map { |t_m| "team_member_#{t_m.id}" })
    end

    def second_to_last
      raise 'Subclass has not overridden second_to_last instance variable'
    end

    def team_members
      @team_members = TeamMember.all
    end

    def validate_params
      return if @team_members.map { |t_m| permissions_params["team_member_#{t_m.id}"] }.include? '1'

      redirect_to :back, alert: 'You must select at least one team member'
    end

    def verify_user
      return if @model.user == current_user

      redirect_to authenticated_user_root_path, alert: 'You cannot view that record'
    end

    def verify_permissions_needed
      return unless @model.permissions.present?

      redirect_to authenticated_user_root_path, alert: 'Permissions have already been set for that record'
    end
  end
end
