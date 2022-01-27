module TeamMembers
  # app/controllers/team_members/crisis_notes_controller.rb
  class CrisisNotesController < TeamMembersApplicationController
    before_action :crisis_event
    before_action :crisis_note, only: :show
    before_action :team_member_crisis_note, only: :update
    before_action :crisis_note_params, only: %i[create update]
    after_action :email, only: %i[create update], unless: -> { @new_crisis_note.nil? }

    # POST /crisis_events/:crisis_event_id/notes
    def create
      if (@new_crisis_note = create_note)
        redirect_to crisis_event_path(@crisis_event), flash: { success: 'Successfully added note!' }
      else
        error_redirect
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
      nothing_to_update_redirect and return unless @crisis_note.changes?(crisis_note_params)

      CrisisNote.transaction do
        @new_crisis_note = create_note(replacing: @crisis_note)
        @crisis_note.update!(replaced_by: @new_crisis_note)
      end

      redirect_to crisis_event_note_path(@crisis_event, @new_crisis_note),
                  flash: { success: 'Successfully updated note!' }
    rescue ActiveRecord::RecordInvalid
      error_redirect
    end

    protected

    def email
      crisis_type = @crisis_event.crisis_type.category
      crisis_notes = @crisis_event.crisis_notes
                                  .includes(:team_member)
                                  .order(created_at: :asc)
      user = User.find(@crisis_event.user_id)
      TeamMember.admins.each do |admin|
        AdminMailer.updated_crisis_email(user, admin, @crisis_event, crisis_type, crisis_notes).deliver_now
      end
    end

    private

    def create_note(replacing: nil)
      @crisis_event.crisis_notes.create!(team_member: current_team_member,
                                         content: crisis_note_params[:content],
                                         replacing: replacing)
    end

    def error_redirect
      redirect_to crisis_event_path(@crisis_event), flash: { error: 'Something went wrong. Please try again.' }
    end

    def nothing_to_update_redirect
      redirect_back(fallback_location: crisis_event_path(@crisis_event), flash: { error: 'Nothing to update!' })
    end

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

    def team_member_crisis_note
      @crisis_note = current_team_member.crisis_notes.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: crisis_event_path(@crisis_event), flash: { error: 'Note not found' })
    end

    def crisis_note_params
      params.require(:crisis_note).permit(:content)
    end
  end
end
