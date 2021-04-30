module TeamMembers
  # app/controllers/team_members/crisis_events_controller.rb
  class CrisisEventsController < TeamMembersApplicationController
    include Pagination
    before_action :crisis_event, except: %i[index active]

    # GET /crisis_events/active
    def active
      @crisis_events = CrisisEvent.active.includes(:user, :crisis_type).order(updated_at: :desc)

      render 'active'
    end

    # GET /crisis_events/:id
    def show
      @note = CrisisNote.new
      @notes = @crisis_event.crisis_notes.includes(:team_member).order(updated_at: :desc)

      render 'show'
    end

    # PUT /crisis_events/:id/close
    def close
      closed = @crisis_event.update({ closed: true, closed_by: current_team_member, closed_at: Time.now })

      redirect_to crisis_event_path(@crisis_event),
                  notice: closed ? 'Crisis event has been closed' : 'Crisis event could not be closed'
    end

    protected

    def resources
      CrisisEvent.closed.includes(:user, :crisis_type).order(closed_at: :desc)
    end

    def search
      CrisisEvent.closed.includes(:user, :crisis_type)
                 .joins(:user, :crisis_type)
                 .where("#{user_search} or #{crisis_search}", wildcard_query)
                 .order(closed_at: :desc)
    end

    private

    def crisis_event
      @crisis_event = CrisisEvent.includes(:user, :crisis_type).find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: active_crisis_events_path, flash: { error: 'Crisis event not found' })
    end

    def crisis_search
      'lower(crisis_types.category) similar to lower(:query) or lower(additional_info) similar to lower(:query)'
    end

    def subheading_stats
      # TODO: Add stats for closed crisis events index
    end
  end
end
