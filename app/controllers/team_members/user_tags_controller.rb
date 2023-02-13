module TeamMembers
  # app/controllers/team_members/user_tags_controller.rb
  class UserTagsController < TeamMembersApplicationController
    before_action :selected_tag, only: :index
    before_action :set_breadcrumbs, only: :index

    # GET /tags/:tag_id/user_tags
    include Pagination
    before_action :user, only: %i[create destroy]
    before_action :user_tag, only: :destroy
    before_action :user_tag_params, :tag, only: :create

    # POST /users/:user_id/tags
    def create
      @user_tag = UserTag.create!(team_member: current_team_member, user: @user, tag: @tag)
      redirect_back(fallback_location: user_path(@user),
                    flash: { success: "Tag (#{@user_tag.tag.tag}) added to #{@user.full_name}" })
    end

    # DELETE /users/:user_id/tags/:id
    def destroy
      @user_tag.destroy!
      redirect_back(fallback_location: user_path(@user),
                    flash: { success: "Tag (#{@user_tag.tag.tag}) removed from #{@user.full_name}" })
    end

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
      @sort = 'tagged_on'
      { 'created_at': @direction }
    end

    private

    def tag
      if user_tag_params[:new_tag].present?
        @tag = Tag.new(tag: user_tag_params[:new_tag].downcase.titleize, team_member: current_team_member)
        if @tag.save
          @tag
        else
          error_redirect
        end
      else
        @tag = Tag.find(user_tag_params[:tag].to_i)
      end
    end

    def error_redirect
      redirect_to user_path(@user), flash: { error: 'Something went wrong. Please only use standard
        characters and punctuation' }
    end

    def selected_tag
      @tag = Tag.find(params[:tag_id])
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

    def set_breadcrumbs
      path = action_name == 'index' ? nil : user_tags_path
      add_breadcrumb('Tags', tags_path, 'fas fa-tag')
      add_breadcrumb(@tag.tag, path)
    end
  end
end
