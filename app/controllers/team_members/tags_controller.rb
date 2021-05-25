module TeamMembers
  # app/controllers/team_members/tags_controller.rb
  class TagsController < TeamMembersApplicationController
    before_action :new_tag, :tagged_count, only: :index
    before_action :tag_params, only: :create
    include Pagination

    def create
      existing_tag = Tag.where(tag: tag_params[:tag].titleize).present?
      debugger
      redirect_back(fallback_location: tags_path, notice: 'That tag already exists') and return if existing_tag

      Tag.create!(tag: tag_params[:tag].titleize, team_member: current_team_member)
    end

    protected

    def resources
      @resources = Tag.includes(:team_member, :user_tags)
                      .all
                      .order(sort)
    end

    def search
      @resources = Tag.includes(:team_member, :user_tags)
                      .joins(:team_member)
                      .where("#{team_member_search} or #{tags_search}", wildcard_query)
                      .order(sort)
    end

    def subheading_stats
      @count_in_last_week = @resources.created_in_last_week.size
      @count_in_last_month = @resources.created_in_last_month.size
      @tagged_count_in_last_week = @resources.tagged_in_last_week.size
      @tagged_count_in_last_month = @resources.tagged_in_last_month.size
    end

    def sort
      { 'created_at': %w[asc desc].include?(params[:sort]) ? params[:sort] : :desc }
    end

    private

    def new_tag
      @tag = Tag.new
    end

    def tag_params
      params.require(:tag).permit(:tag)
    end

    def tagged_count
      @tagged_count = Tag.all.tagged.size
    end

    def tags_search
      'lower(tags.tag) similar to lower(:query)'
    end
  end
end
