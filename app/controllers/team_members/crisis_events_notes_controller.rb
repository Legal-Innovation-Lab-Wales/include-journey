module TeamMembers
  # app/controllers/team_members/crisis_events_notes_controller.rb
  class CrisisEventsNotesController < TeamMembersApplicationController
    before_action :crisis_event, only: %i[new create]

    # POST /crisis_events/:crisis_event_id/crisis_events_notes
    def create
      if (@note = CrisisNote.create!({ team_member: current_team_member, crisis_event: @crisis_event, content: crisis_notes_params[:content] }))
        redirect_to crisis_event_path(@crisis_event), success: 'Note created'
      else
        redirect_to crisis_event_path(@crisis_event), error: 'Note could not be created'
      end
    end

    private

    def crisis_event
      @crisis_event = CrisisEvent.includes(:user, :crisis_type).find(params[:crisis_event_id])
    end

    def crisis_notes_params
      params.require(:crisis_note).permit(:content)
    end
  end
end
