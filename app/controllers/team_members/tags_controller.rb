module TeamMembers
  # app/controllers/team_members/tags_controller.rb
  class TagsController < TeamMembersApplicationController
    include Pagination

    protected

    def resources
      @resources = Tag.includes(:team_member, :user_tags).all
    end

    def search
      self.resources
    end
  end
end
