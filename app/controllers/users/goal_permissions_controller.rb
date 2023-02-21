module Users
    class GoalPermissionsController < PermissionsController
        before_action :permissions, :can_add, :set_breadcrumbs

        def index
            add_breadcrumb('Manage permissions', nil, 'fas fa-book')
            @select_list = { 'All': 0, "Long Term": 1, "Short Term": 2 }
            @default_permission = false

        end

        def new
            if !can_add
                redirect_to goal_permissions_path(current_user), flash: { error: 'No new Team member to add' }
            end
            add_breadcrumb('Add permission', nil, 'fas fa-book')
            @select_list = { 'All': 0, "Long Term": 1, "Short Term": 2 }
            @default_permission = false

        end

        def create
            if !can_add
                redirect_to goal_permissions_path(current_user), flash: { error: 'No new Team member to add' }
            end
            is_short_term = permissions_params[:goal_type] === '0' || permissions_params[:goal_type] === '2'
            is_long_term = permissions_params[:goal_type] === '0' || permissions_params[:goal_type] === '1'

            @team_members.each do |team_member|
                next if permissions_params["team_member_#{team_member.id}"].to_i.zero?
        
                current_user.goal_permissions.create!({team_member: team_member, short_term: is_short_term, long_term: is_long_term})
            end

            redirect_to goal_permissions_path(current_user), flash: { success: 'Permissions Shared successfully' }
        end

        def destroy
            permission = @model.find(params[:goal_permission_id])

            permission.destroy!

            redirect_to goal_permissions_path(current_user), flash: { success: 'Permission successfully revoked' }
        end

        def second_to_last
        end

        protected
        def model
            @model = current_user.goal_permissions
        end

        def permissions_params
            params.require(:goal_permission).permit(:goal_type, @team_members.map { |t_m| "team_member_#{t_m.id}" })
        end

        def permissions
            @permissions = @model.collect { |permission| { id: permission.team_member_id } }
        end

        def can_add
            @can_add = @permissions.length < @team_members.length
        end
        def set_breadcrumbs
            add_breadcrumb('My Goals', goals_path, 'fas fa-tasks')
        end

    end
end
