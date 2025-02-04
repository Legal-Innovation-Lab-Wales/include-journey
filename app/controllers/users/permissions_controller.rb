# frozen_string_literal: true

module Users
  # app/controllers/users/permissions_controller.rb
  class PermissionsController < UsersApplicationController
    before_action :team_members, :model

    before_action :permissions_params, only: %i[create update]

    before_action :second_to_last, only: :new
    before_action :last_permissions, only: :new, if: -> { @second_to_last.present? }

    before_action :current_permissions, only: :edit

    def new
      raise 'Subclass has not overridden permissions new function'
    end

    def edit
      raise 'Subclass has not overridden permissions edit function'
    end

    def create
      @model.permissions.destroy_all

      @team_members.each do |team_member|
        next if permissions_params["team_member_#{team_member.id}"].to_i.zero?

        @model.permissions.create!(team_member: team_member)
      end

      redirect_to path, success: 'Sharing permissions for team members successfully set'
    end

    protected

    def path
      raise 'Subclass has not overridden path function'
    end

    def last_permissions
      @last_permissions = @second_to_last.permissions.collect do |permission|
        {id: permission.team_member_id}
      end
    end

    def current_permissions
      @current_permissions = @model.permissions.collect do |permission|
        {id: permission.team_member_id}
      end
    end

    def model
      raise 'Subclass has not overridden model instance variable'
    end

    def permissions_params
      params.require(@model.class.model_name.singular)
        .permit(@team_members.map { |t_m| "team_member_#{t_m.id}" })
    end

    def second_to_last
      raise 'Subclass has not overridden second_to_last instance variable'
    end

    def team_members
      @team_members = current_user.team_members
        .order(:created_at)
    end
  end
end
