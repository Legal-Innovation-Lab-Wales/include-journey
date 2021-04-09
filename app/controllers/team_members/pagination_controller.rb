module TeamMembers
  # app/controllers/team_members/pagination_controller.rb
  class PaginationController < TeamMembersApplicationController
    def index
      @page = query_params[:page].to_i < 1 ? 1 : query_params[:page].to_i
      @query = query_params[:query]
      @resources_per_page ||= 5
      @resources = resources
      @count = @resources.size
      subheading_stats
      @last_page = offset + limit >= @count
      @final_page = (@count.to_f / limit).ceil
      @resources = @resources.offset(offset).limit(limit)
      @resources.present? ? render('index') : redirect
    end

    protected

    def resources
      raise 'Subclass has not overridden resources function'
    end

    def limit
      if query_params[:limit].present?
        limit = query_params[:limit].to_i

        if limit.positive? && limit <= @resources_per_page * 10
          limit
        else
          redirect_back(fallback_location: authenticated_team_member_root_path, alert: 'Invalid Limit')
        end
      else
        @resources_per_page
      end
    end

    def offset
      (@page - 1) * limit
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
      { query: "%#{@query.split.join('%|%')}%" }
    end


  end
end
