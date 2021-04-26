module TeamMembers
  # app/controllers/team_members/crisis_notes_controller.rb
  class CrisisNotesController < CrisisNotesController


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

    end

    # PUT /crisis_events/:crisis_event_id/notes/:id
    def update
      
    end

    private

    def crisis_notes_params
      params.require(:crisis_note).permit(:content)
    end
  end
end