module TeamMembers
  # app/controllers/team_members/notes_controller.rb
  class NotesController < TeamMembersApplicationController
    before_action :note_params, :user, only: :create

    # POST /notes
    def create
      @note = current_team_member.notes.create!(content: note_params[:content],
                                                visible_to_user: note_params[:visible_to_user],
                                                user: @user)
      redirect_to user_path(@user), notice: @note ? 'Note added!' : "The note couldn't be added. Please try again."
    end

    # GET /notes/:id/edit
    def edit
      # render 'edit'
    end

    # POST /notes/:id/update
    def update
      # Do not change existing record, create new record and set replaced_by to the new record.
    end

    # GET /notes/:id
    def show
      # Show all notes in the edit-chain.
    end

    private

    def user
      @user = User.find(params[:user_id])
    end

    def note_params
      params.require(:note).permit(:content, :visible_to_user)
    end
  end
end
