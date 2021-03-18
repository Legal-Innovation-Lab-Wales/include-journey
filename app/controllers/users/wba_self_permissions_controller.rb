module Users
  # app/controllers/users/wba_self_permission_controller.rb
  class WbaSelfPermissionsController < PermissionsController
    skip_before_action :wba_self_permissions_required

    # GET /wba_selves/:wba_self_id/wba_self_permissions/new
    def new
      render 'new'
    end

    # POST /wba_selves/:wba_self_id/wba_self_permissions/create
    def create
      @team_members.each do |team_member|
        next if permissions_params["team_member_#{team_member.id}"].to_i.zero?

        WbaSelfPermission.create!({ wba_self: @model, team_member: team_member })
      end

      redirect_to wba_self_path(@model), alert: 'Sharing permissions for team members successfully set'
    end

    protected

    def new_path
      new_wba_self_permission_path(@model)
    end

    def model
      @model = WbaSelf.includes(:wba_self_permissions).find(params[:wba_self_id])
    end

    def second_to_last
      @second_to_last = current_user.wba_selves.includes(:wba_self_permissions).second_to_last
    end
  end
end
