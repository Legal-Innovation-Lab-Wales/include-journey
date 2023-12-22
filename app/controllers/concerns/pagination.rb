# app/controllers/concerns/pagination.rb
module Pagination
  extend ActiveSupport::Concern
  included do
    before_action :pagination, only: :index
  end

  def self.permitted_params
    %i[view page query tag assigned type radius postcode limit sort direction viewed feeling on user_id team_member_id 
       survey_id section_id comment_section_id folder_id]
  end

  protected

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def pagination
    @page = pagination_params[:page].present? ? pagination_params[:page].to_i : 1
    @view = pagination_params[:view] if pagination_params[:view].present?
    @query = pagination_params[:query]
    @direction = %w[asc desc].include?(pagination_params[:direction]) ? pagination_params[:direction] : 'desc'
    @resources_per_page = resources_per_page
    @resources = @query.present? ? search : resources
    @count = @resources.count
    @limit = limit
    subheading_stats
    @last_page = (@count.to_f / @limit).ceil
    if resources.kind_of?(Array) #Different methods based on array or activeobject array
      @resources = @resources[offset, @limit]
    else
      @resources = @resources.offset(offset).limit(@limit)
    end
    render_custom_view
  end

  def render_custom_view
    if @resources.present?
      if @view.present?
        session[:custom_view] = @view
        render "#{@view}_index"
      else
        session.delete(:custom_view) if session.key?(:custom_view)
        render 'index'
      end
    else
      redirect
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

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
    @query = ActiveRecord::Base::sanitize_sql_like(@query)
    { query: "%#{@query.split.join('%|%')}%" }
  end

  def pagination_params
    params.permit(Pagination.permitted_params)
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
