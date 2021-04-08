module TeamMembers
  # app/controllers/team_members/pagination_controller.rb
  class PaginationController < TeamMembersApplicationController
    def index
      @page = page
      @query = query_params[:query]
      multiple unless @multiple
      resources unless @resources
      limit_resources
      @resources.present? ? render('index') : redirect
    end

    protected

    def count
      @resources.count
    end

    def resources
      raise 'Subclass has not overridden resources function'
    end

    def last_page
      @last_page = offset + @limit >= count
      @final_page = (count.to_f / @limit).ceil
    end

    def limit
      if query_params[:limit].present?
        limit = query_params[:limit].to_i

        if limit.positive? && limit <= multiple * 10
          @limit = limit
        else
          redirect_back(fallback_location: authenticated_team_member_root_path, alert: 'Invalid Limit')
        end
      else
        @limit = multiple
      end
    end

    def multiple
      @multiple = 5
    end

    def offset
      (page - 1) * @limit
    end

    def page
      return 1 if query_params[:page].to_i < 1

      query_params[:page].to_i
    end

    def limit_resources
      @count = count
      limit
      last_page
      @resources = @resources.offset(offset).limit(@limit)
    end

    def query_params
      params.permit(:page, :query, :limit)
    end

    def redirect
      redirect_back(fallback_location: authenticated_team_member_root_path, alert: 'No Results Found')
    end

    def user_search
      'lower(users.first_name) similar to lower(:query) or lower(users.last_name) similar to lower(:query)'
    end

    def wildcard_query
      { query: "%#{query_params[:query].split.join('%|%')}%" }
    end
  end
end
