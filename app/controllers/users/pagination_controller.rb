module Users
  # app/controllers/users/pagination_controller.rb
  class PaginationController < UsersApplicationController
    before_action :query_params, :page, :query, :limit, :offset, :resources,
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
      @final_page = (@count.to_f / @limit).ceil
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

    def query
      @query = query_params[:query]
    end

    def query_params
      params.permit(:page, :query)
    end

    def redirect
      return if @resources.present?

      redirect_back(fallback_location: authenticated_user_root_path, alert: 'None found')
    end

    def user_search
      'lower(users.first_name) like lower(:query) or lower(users.last_name) like lower(:query)'
    end

    def wildcard_query
      { query: "%#{@query}%" }
    end
  end
end
