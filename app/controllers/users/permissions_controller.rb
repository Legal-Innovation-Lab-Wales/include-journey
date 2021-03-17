module Users
  # app/controllers/users/wba_self_permission_controller.rb
  class PermissionsController < UsersApplicationController
    before_action :team_members, :model
    before_action :restrict_user, unless: -> { @model.user == current_user }
    before_action :permissions_set, if: -> { @model.permissions.present? }

    before_action :permissions_params, only: :create
    before_action :at_least_one, only: :create, unless: lambda {
      @team_members.map { |t_m| permissions_params["team_member_#{t_m.id}"] }.include? '1'
    }

    before_action :second_to_last, only: :new
    before_action :last_permissions, only: :new, if: -> { @second_to_last.present? }

    def new
      raise 'Subclass has not overridden permissions new function'
    end

    def create
      @team_members.each do |team_member|
        next if permissions_params["team_member_#{team_member.id}"].to_i.zero?

        @model.permissions.create!({ team_member: team_member })
      end

      redirect_to path, alert: 'Sharing permissions for team members successfully set'
    end

    protected

    def new_path
      raise 'Subclass has not overridden new path function'
    end

    def path
      raise 'Subclass has not overridden path function'
    end

    def last_permissions
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
      @team_members = TeamMember.all.order(:created_at)
    end

    def at_least_one
      redirect_to new_path, alert: 'You must select at least one team member'
    end

    def restrict_user
      redirect_to authenticated_user_root_path, alert: 'You cannot view that record'
    end

    def permissions_set
      redirect_to authenticated_user_root_path, alert: 'Permissions have already been set for that record'
    end
  end
end
