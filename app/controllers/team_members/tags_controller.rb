module TeamMembers
  # app/controllers/team_members/tags_controller.rb
  class TagsController < TeamMembersApplicationController
    include Pagination
    before_action :user, :user_tag, only: :destroy

    # DELETE /users/:user_id/user_tags/:id
    def destroy
      @user_tag.destroy!
      redirect_back(fallback_location: authenticated_team_member_root_path,
                    flash: { success: "Tag (#{@user_tag.tag.tag}) removed from #{@user.full_name}" })
    end

    protected

    def resources
      @resources = Tag.includes(:team_member, :user_tags).all
    end

    def search
      self.resources
    end

    private

    def user
      @user = User.find(params[:user_id])
    end

    def user_tag
      @user_tag = @user.user_tags.find(params[:id])
    end
  end
end
