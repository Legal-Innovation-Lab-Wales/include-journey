module TeamMembers
  # app/controllers/team_members/user_tags_controller.rb
  class UserTagsController < TeamMembersApplicationController
    before_action :tag

    # GET /tags/:tag_id/user_tags
    include Pagination

    protected

    def resources
      @resources = @tag.user_tags.includes(:team_member, :user)
                       .order(created_at: :desc)
    end

    def search
      @resources = @tag.user_tags.includes(:team_member, :user)
                       .joins(:team_member)
                       .where("#{team_member_search} or #{user_search}", wildcard_query)
                       .order(created_at: :desc)
    end

    private

    def tag
      @tag = Tag.find(params[:tag_id])
    end
  end
end
