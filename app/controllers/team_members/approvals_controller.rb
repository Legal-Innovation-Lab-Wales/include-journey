module TeamMembers
  # app/controllers/team_members/approvals_controller.rb
  class ApprovalsController < TeamMembersApplicationController
    before_action :set_breadcrumbs
    before_action :redirect_back_unless_admin
    include Pagination

    def index
      render 'index'
    end

    def approve
      user = User.find(params[:user_id])
      user.approved = true
      user.save

      redirect_to approvals_path, flash: { success: 'User Approved' }
    rescue ActiveRecord::RecordNotFound
      redirect_to approvals_path, flash: { error: 'User not Found' }
    end

    def new
      redirect_to :index
    end

    def bulk_action
      unless params[:user_ids]
        return redirect_to approvals_path, flash: { error: 'No users selected' }
      end

      is_approve = params[:status] == '1'

      @selected_users = User.where(id: params.fetch(:user_ids, []).compact)

      @selected_users.each do |user|
        if is_approve
          user.approved = true
          user.approved_at = DateTime.now
          user.save!
        else
          user.unapprove
        end
      end

      redirect_to user_data.count.zero? ? root_path : approvals_path, flash: { success: "#{is_approve ? 'Approvals' : 'Rejections' } Successful" }
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

    private

    def redirect_back_unless_admin
      return if current_team_member.admin?

      flash[:error] = 'You are not allowed to do that!'
      redirect_back(fallback_location: root_path)
    end
  end
end
