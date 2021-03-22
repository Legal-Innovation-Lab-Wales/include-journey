module TeamMembers
  # app/controllers/team_members/notes_controller.rb
  class NotesController < TeamMembersApplicationController
    before_action :set_note, only: %i[show edit update destroy]
    before_action :note_params, only: :create
    before_action :user

    # GET /notes or /notes.json
    def index
      @notes = Note.user
    end

    # GET /notes/1 or /notes/1.json
    def show; end

    # GET /notes/1/edit
    def edit; end

    # POST /notes or /notes.json
    def create
      @note = Note.create!({ content: note_params[:content],
                             visible_to_user: note_params[:visible_to_user],
                             user: @user,
                             team_member: current_team_member })

      redirect_to user_path(@user), notice: @note ? 'Note added!' : "We couldn't create the note. Please try again."
    end

    # PATCH/PUT /notes/1 or /notes/1.json
    def update
      redirect_to user_path(@user), notice: @note.update!(note_params) ? 'Note updated!' : "We couldn't create the note. Please try again."
    end

    # DELETE /notes/1 or /notes/1.json
    def destroy
      @note.destroy
      redirect_to notes_url, notice: 'Note was successfully destroyed.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    def user
      @user = User.find(params[:user_id])
    end

    # Only allow a list of trusted parameters through.
    #
    def note_params
      params.require(:note).permit(:content, :visible_to_user)
    end
  end
end
