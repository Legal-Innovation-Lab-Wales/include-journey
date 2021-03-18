module TeamMembers
  # app/controllers/team_members/pagination_controller.rb
  class PaginationController < TeamMembersApplicationController
    before_action :page, :limit, :offset, :resources, :count, :last_page, :limit_resources, only: :index
    before_action :redirect, only: :index, unless: -> { @resources.present? }

    def index
      render 'index'
    end

    protected

    RESOURCES_PER_PAGE = 5

    def count
      @count = @resources.count
    end

    def resources
      raise 'Subclass has not overridden resources function'
    end

    def last_page
      @last_page = @offset + @limit >= @count
    end

    def limit
      @limit = RESOURCES_PER_PAGE
    end

    def offset
      @offset = (@page - 1) * @limit
    end

    def page
      @page = params[:page_number].to_i
    end

    def limit_resources
      @resources = @resources.offset(@offset).limit(@limit).order(created_at: :desc)
    end

    def redirect
      redirect_back(fallback_location: root_path, alert: 'No resources found')
    end
  end
end
