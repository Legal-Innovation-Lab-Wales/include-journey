module TeamMembers
    # app/controllers/team_members/approvals_controller.rb
    class ApprovalsController < TeamMembersApplicationController
        include Pagination

        def index
            render "index"
        end
        
        def approve
            user = User.find(params[:user_id])
            user.skip_confirmation!
            user.save

            redirect_to approvals_path, flash: { success: 'User Approved' }
        rescue ActiveRecord::RecordNotFound
            redirect_to approvals_path, flash: { error: 'User not Found' }
        end  

        def new
            redirect_to :index
        end

        def bulk_action
            if !params[:user_ids]
                return redirect_to approvals_path, flash: { error: 'No users selected' }
            end
            
            @selected_users = User.where(id: params.fetch(:user_ids, []).compact)
            @selected_users.each do |user| 
                user.skip_confirmation!
                user.save!
            end
            redirect_to approvals_path, flash: { success: 'Approvals Successful' }
            rescue ActiveRecord::RecordNotFound
                redirect_to approvals_path, flash: { error: 'No users selected' }
        end
        protected
        def user_data
            User.where("confirmed_at IS NULL")
        end

        def resources
          user_data
        end
    
        def search
            user_data.where(user_search, wildcard_query)
        end
      
        def resources_per_page
          6
        end
    
    end
end
