module TeamMembers
  # app/controllers/team_members/crisis_events_pages_controller.rb
  class CrisisEventsPagesController < TeamMembersApplicationController
    before_action :page, :offset, :crisis_events, only: :index
    before_action :count, :last_page, only: :index, if: -> { @crisis_events.present? }
    before_action :redirect, only: :index, unless: -> { @crisis_events.present? }

    LIMIT = 5

    # GET /crisis_events/page/:page_number
    def index
      render 'index'
    end

    private

    def count
      @count = CrisisEvent.closed.count
    end

    def crisis_events
      @crisis_events = CrisisEvent.closed.includes(:user, :crisis_type).offset(@offset).limit(LIMIT).order(closed_at: :desc)
    end

    def last_page
      @last_page = @offset + LIMIT >= @count
    end

    def offset
      @offset = (@page - 1) * LIMIT
    end

    def page
      @page = params[:page_number].to_i

      return if @page.positive?

      redirect_to authenticated_team_member_root_path, alert: 'Page number cannot be below 1'
    end

    def redirect
      redirect_to authenticated_team_member_root_path, alert: 'No crisis events found'
    end
  end
end
