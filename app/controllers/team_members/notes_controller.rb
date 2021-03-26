module TeamMembers
  # app/controllers/team_members/notes_controller.rb
  class NotesController < TeamMembersApplicationController
    before_action :set_note, only: %i[show edit update destroy]
    before_action :note_params, only: :create
    before_action :user

    # POST /notes
    def create
      @note = current_team_member.notes.create!(content: note_params[:content],
                                                visible_to_user: note_params[:visible_to_user],
                                                user: @user)
      redirect_to user_path(@user), notice: @note ? 'Note added!' : "We couldn't create the note. Please try again."
    end

    # PATCH/PUT /notes/1
    def update
      redirect_to user_path(@user), notice: @note.update!(note_params) ? 'Note updated!' : "We couldn't create the note. Please try again."
    end

    # DELETE /notes/1
    def destroy
      @note.destroy
      redirect_to notes_url, notice: 'Note was successfully destroyed.'
    end

    private

    def set_note
      @note = Note.find(params[:id])
    end

    def user
      @user = User.find(params[:user_id])
    end

    def note_params
      params.require(:note).permit(:content, :visible_to_user)
    end
  end
end
