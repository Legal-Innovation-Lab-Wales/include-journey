module TeamMembers
    # app/controllers/team_members/assign_users_controller.rb
    class AssignUsersController < TeamMembersApplicationController
      before_action :set_breadcrumbs, :team_member
      include Pagination
      
      def index
        @team_member = params[:team_member_id].present? ? TeamMember.find(params[:team_member_id]) : current_team_member
      end

      def approve
        user = User.find(params[:user_id])
        if !user
          return redirect_to team_member_users_path, flash: { error: 'No user selected' }
        end
        is_assign = !params[:remove].present?
        is_assign ? user.assign_team_member(team_member.id) : user.remove_team_member(team_member.id)
        redirect_to team_member_users_path, flash: { success: "Success" }
      end

      def create
        unless params[:user_ids]
          return redirect_to team_member_users_path, flash: { error: 'No users selected' }
        end
        team_member = params[:team_member_id].present? ? TeamMember.find(params[:team_member_id]) : current_team_member
    
        user_ids = params.fetch(:user_ids, []).compact

        @selected_users = User.where(id: user_ids)

        is_assign = params[:status] == '1'
    
        @selected_users.each do |user|
          is_assign ? user.assign_team_member(team_member.id) : user.remove_team_member(team_member.id)
        end
    
        redirect_to team_member_users_path, flash: { success: "Success" }
      rescue ActiveRecord::RecordNotFound
          redirect_to approvals_path, flash: { error: 'No users selected' }
      end

      private

      def resources
        team_member
        User.order(id: :asc)
      end

      def team_member
        @team_member = params[:team_member_id].present? ? TeamMember.find(params[:team_member_id]) : current_team_member
      end

      def resources_per_page
        20
      end

      def user_search
        'lower(first_name) similar to lower(:query) or lower(last_name) similar to lower(:query)'
      end

      def search
        resources.where(user_search, wildcard_query)
      end

      def set_breadcrumbs
        add_breadcrumb('Team Members', team_members_path, 'fas fa-users')
        add_breadcrumb(team_member.full_name, team_member_path(team_member), 'fas fa-user')
        add_breadcrumb('Assign Users', nil, 'fas fa-check')
      end
    end
  end
  