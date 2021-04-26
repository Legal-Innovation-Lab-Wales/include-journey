module TeamMembers
  # app/controllers/team_members/crisis_notes_controller.rb
  class CrisisNotesController < TeamMembersApplicationController
    before_action :crisis_event
    before_action :crisis_note, only: :show

    # POST /crisis_events/:crisis_event_id/notes
    def create
      if @crisis_event.crisis_notes.create!({ team_member: current_team_member,
                                              content: crisis_notes_params[:content] })
        redirect_to crisis_event_path(@crisis_event), notice: 'Note created'
      else
        redirect_to crisis_event_path(@crisis_event), error: 'Note could not be created'
      end
    end

    # GET /crisis_events/:crisis_event_id/notes/:id
    def show
      if @crisis_note.replaced_by.present?
        redirect_to crisis_event_note_path(@crisis_event, @crisis_note.latest)
      else
        @crisis_notes = []
        @crisis_note.chain(@crisis_notes)
      end
    end

    # PUT /crisis_events/:crisis_event_id/notes/:id
    def update

    end

    private

    def crisis_event
      @crisis_event = CrisisEvent.includes(:user, :crisis_type).find(params[:crisis_event_id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: active_crisis_events_path, flash: { error: 'Crisis event not found' })
    end

    def crisis_note
      @crisis_note = CrisisNote.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: crisis_event_path(@crisis_event), flash: { error: 'Note not found' })
    end

    def crisis_notes_params
      params.require(:crisis_note).permit(:content)
    end
  end
end