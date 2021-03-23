module Users
  # app/controllers/users/pagination_controller.rb
  class PaginationController < UsersApplicationController
    before_action :query_params, :page, :limit, :offset, :resources,
                  :count, :last_page, :limit_resources, :redirect, only: :index

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
      @page = params[:page].to_i

      @page = 1 if @page < 1
    end

    def limit_resources
      @resources = @resources.offset(@offset).limit(@limit).order(created_at: :desc)
    end

    def query_params
      params.permit(:page)
    end

    def redirect
      return if @resources.present?

      redirect_back(fallback_location: root_path, alert: 'None found')
    end
  end
end
