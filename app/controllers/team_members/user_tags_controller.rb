module TeamMembers
  # app/controllers/team_members/user_tags_controller.rb
  class UserTagsController < TeamMembersApplicationController
    before_action :tag

    # GET /tags/:tag_id/user_tags
    include Pagination

    protected

    def resources
      @resources = @tag.user_tags.includes(:team_member, :user)
                       .order(sort)
    end

    def search
      @resources = @tag.user_tags.includes(:team_member, :user)
                       .joins(:team_member)
                       .where("#{team_member_search} or #{user_search}", wildcard_query)
                       .order(sort)
    end

    def subheading_stats
      @count_in_last_week = @resources.created_in_last_week.size
      @count_in_last_month = @resources.created_in_last_month.size
    end

    def sort
      { 'created_at': %w[asc desc].include?(params[:sort]) ? params[:sort] : :desc }
    end

    private

    def tag
      @tag = Tag.find(params[:tag_id])
    end
  end
end
