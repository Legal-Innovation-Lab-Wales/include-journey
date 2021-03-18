module TeamMembers
  # app/controllers/team_members/crisis_events_controller.rb
  class CrisisEventsController < PaginationController
    before_action :crisis_events, only: :active
    before_action :crisis_event, only: %i[show close add_note]
    before_action :note, :notes, only: :show

    # GET /crisis_events/active
    def active
      render 'active'
    end

    # GET /crisis_events/:id
    def show
      render 'show'
    end

    # PUT /crisis_events/:id/close
    def close
      closed = @crisis_event.update({ closed: true, closed_by: current_team_member, closed_at: Time.now })

      redirect_to crisis_event_path(@crisis_event), alert: closed ? 'Crisis event has been closed' : 'Crisis event could not be closed'
    end

    # POST /crisis_events/:id/note
    def add_note
      if CrisisNote.create!({ team_member: current_team_member, crisis_event: @crisis_event,
                              content: crisis_notes_params[:content] })
        redirect_to crisis_event_path(@crisis_event), alert: 'Note created'
      else
        redirect_to crisis_event_path(@crisis_event), alert: 'Note could not be created'
      end
    end

    protected

    def resources
      @resources = CrisisEvent.closed.includes(:user, :crisis_type)
    end

    private

    def crisis_event
      @crisis_event = CrisisEvent.includes(:user, :crisis_type).find(params[:id])
    end

    def crisis_events
      @crisis_events = CrisisEvent.active.includes(:user, :crisis_type).order(updated_at: :desc)
    end

    def note
      @note = CrisisNote.new
    end

    def notes
      @notes = @crisis_event.crisis_notes.includes(:team_member).order(updated_at: :desc)
    end

    def crisis_notes_params
      params.require(:crisis_note).permit(:content)
    end
  end
end
