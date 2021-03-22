module TeamMembers
  # app/controllers/team_members/crisis_events_controller.rb
  class CrisisEventsController < TeamMembersApplicationController
    before_action :crisis_events, only: :index
    before_action :crisis_event, only: %i[show close]
    before_action :note, :notes, only: :show

    # GET /crisis_events
    def index
      render 'index'
    end

    # GET /crisis_events/:id
    def show
      render 'show'
    end

    # PUT /crisis_events/:id/close
    def close
      if @crisis_event.update({ closed: true, closed_by: current_team_member, closed_at: Time.now })
        redirect_to crisis_event_path(@crisis_event), notice: 'Crisis event has been closed'
      else
        redirect_to crisis_event_path(@crisis_event), error: 'Crisis event could not be closed'
      end
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
  end
end
