# app/controllers/concerns/pagination.rb
module Pagination
  extend ActiveSupport::Concern
  included do
    before_action :pagination, only: :index
  end

  protected

  # rubocop:disable Metrics/AbcSize
  def pagination
    @page = pagination_params[:page].present? ? pagination_params[:page].to_i : 1
    @query = pagination_params[:query]
    @resources_per_page = resources_per_page
    @resources = @query.present? ? search : resources
    @count = @resources.count
    @limit = limit
    subheading_stats
    @last_page = (@count.to_f / @limit).ceil
    @resources = @resources.offset(offset).limit(@limit)
    @resources.present? ? render('index') : redirect
  end
  # rubocop:enable Metrics/AbcSize

  def limit
    if pagination_params[:limit].present?
      limit = pagination_params[:limit].to_i

      if limit.positive? && limit <= @resources_per_page * 10
        limit
      else
        redirect_back(fallback_location: root_path, alert: 'Invalid Limit')
      end
    else
      @resources_per_page
    end
  end

  def offset
    (@page - 1) * limit
  end

  def user_search
    'lower(users.first_name) similar to lower(:query) or lower(users.last_name) similar to lower(:query)'
  end

  def team_member_search
    'lower(team_members.first_name) similar to lower(:query) or lower(team_members.last_name) similar to lower(:query)'
  end

  def wildcard_query
    { query: "%#{@query.split.join('%|%')}%" }
  end

  def pagination_params
    params.permit(:page, :query, :limit)
  end

  def resources
    raise 'Resources not overridden'
  end

  def resources_per_page
    5
  end

  def search
    raise 'Search not overridden'
  end

  def subheading_stats; end

  def redirect
    redirect_back(fallback_location: root_path, alert: 'No Results Found')
  end
end
