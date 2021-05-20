module TeamMembers
  # app/controllers/team_members/tags_controller.rb
  class TagsController < TeamMembersApplicationController
    before_action :tagged_count, only: :index
    include Pagination
    before_action :user, only: %i[create destroy]
    before_action :user_tag, only: :destroy
    before_action :user_tag_params, :tag, only: :create

    # POST /users/:user_id/user_tags
    def create
      @user_tag = UserTag.create!(team_member: current_team_member, user: @user, tag: @tag)
      redirect_back(fallback_location: user_path(@user),
                    flash: { success: "Tag (#{@user_tag.tag.tag}) added to #{@user.full_name}" })
    end

    # DELETE /users/:user_id/user_tags/:id
    def destroy
      @user_tag.destroy!
      redirect_back(fallback_location: user_path(@user),
                    flash: { success: "Tag (#{@user_tag.tag.tag}) removed from #{@user.full_name}" })
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

    def tag
      @tag =
        if user_tag_params[:new_tag].present?
          Tag.create!(tag: user_tag_params[:new_tag], team_member: current_team_member)
        else
          Tag.find(user_tag_params[:tag].to_i)
        end
    end

    def tagged_count
      @tagged_count = Tag.all.tagged.size
    end

    def tags_search
      'lower(tags.tag) similar to lower(:query)'
    end

    def user
      @user = User.find(params[:user_id])
    end

    def user_tag
      @user_tag = @user.user_tags.find(params[:id])
    end

    def user_tag_params
      params.require(:user_tag).permit(:tag, :new_tag)
    end
  end
end
