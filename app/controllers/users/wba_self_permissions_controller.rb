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
        next unless permissions_params["team_member_#{team_member.id}"] == '1'

        WbaSelfPermission.create!({ wba_self_id: @model.id, team_member_id: team_member.id })
      end

      redirect_to authenticated_user_root_path, alert: 'Sharing permissions for team members successfully set'
    end

    protected

    def new_path
      new_wba_self_wba_self_permission_path(@model)
    end

    def model
      @model = WbaSelf.include(:wba_self_permissions).find(params[:wba_self_id])
    end

    def second_to_last
      @second_to_last = current_user.wba_selves.includes(:wba_self_permissions).second_to_last
    end
  end
end
