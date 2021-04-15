module TeamMembers
  # app/controllers/team_members/crisis_events_controller.rb
  class CrisisEventsController < PaginationController
    before_action :crisis_event, except: %i[index active]
    before_action :crisis_events, :crisis_events_users, :closed_events, only: %i[index active]

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

    # POST /crisis_events/:id/note
    def add_note
      if @crisis_event.crisis_notes.create!({ team_member: current_team_member,
                                              content: crisis_notes_params[:content] })
        redirect_to crisis_event_path(@crisis_event), notice: 'Note created'
      else
        redirect_to crisis_event_path(@crisis_event), error: 'Note could not be created'
      end
    end

    protected

    def resources
      @resources = if @query.present?
                     CrisisEvent.closed.includes(:user, :crisis_type, :crisis_notes)
                                .joins(:user, :crisis_type)
                                .where("#{user_search} or #{crisis_search}", wildcard_query)
                                .order(closed_at: :desc)
                   else
                     CrisisEvent.closed.includes(:user, :crisis_type).order(closed_at: :desc)
                   end
    end

    private

    def crisis_event
      @crisis_event = CrisisEvent.includes(:user, :crisis_type).find(params[:id])
    end

    def crisis_events
      @crisis_events = CrisisEvent.active.includes(:user, :crisis_type, :crisis_notes).order(updated_at: :desc)
    end

    def crisis_events_users
      @crisis_events_users = @crisis_events.distinct.count(:user_id)
    end

    def closed_events
      @closed_events = @crisis_events.closed
      @closed_events_30_days = @closed_events.where("closed_at >= ?", 30.days.ago)
      @closed_events_7_days = @closed_events.where("closed_at >= ?", 7.days.ago)
    end

    def crisis_search
      'lower(crisis_types.category) similar to lower(:query) or lower(additional_info) similar to lower(:query)'
    end

    def crisis_notes_params
      params.require(:crisis_note).permit(:content)
    end
  end
end
