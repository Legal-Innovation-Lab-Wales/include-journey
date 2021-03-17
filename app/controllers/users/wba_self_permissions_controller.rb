module Users
  # app/controllers/users/wba_self_permission_controller.rb
  class WbaSelfPermissionsController < PermissionsController
    skip_before_action :wba_self_permissions_required

    # GET /wba_selves/:wba_self_id/wba_self_permissions/new
    def new
      render 'new'
    end

    protected

    def path
      wba_self_path(@model)
    end

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
