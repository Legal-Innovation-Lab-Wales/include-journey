module TeamMembers
    # app/controllers/team_members/approvals_controller.rb
    class ApprovalsController < TeamMembersApplicationController
        before_action :set_breadcrumbs
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
            
            isApprove = params[:status] === "1" 

            @selected_users = User.where(id: params.fetch(:user_ids, []).compact)

            @selected_users.each do |user| 
                if isApprove
                    user.approved = true
                    user.approved_at = DateTime.now
                    user.save!
                else
                    user.unapprove
                end
            end

            redirect_to user_data.count === 0 ? root_path : approvals_path, flash: { success: "#{isApprove ? 'Approvals' : 'Rejections' } Successful" }
            rescue ActiveRecord::RecordNotFound
                redirect_to approvals_path, flash: { error: 'No users selected' }
        end
        protected
        def user_data
            User.where(approved: false)
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

        def set_breadcrumbs
            add_breadcrumb('Approvals', nil, 'fas fa-check')
        end
    end
end
