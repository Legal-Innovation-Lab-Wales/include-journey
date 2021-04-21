module TeamMembers
  # app/controllers/team_members/notes_controller.rb
  class NotesController < TeamMembersApplicationController
    before_action :note_params, :user, only: [:create, :update]
    before_action :note, only: :update

    # POST /notes
    def create
      @note = current_team_member.notes.create!(content: note_params[:content],
                                                visible_to_user: note_params[:visible_to_user],
                                                user: @user)
      redirect_to user_path(@user), notice: @note ? 'Note added!' : "The note couldn't be added. Please try again."
    end

    # GET /notes/:id
    def show
      # Show all notes in the edit-chain.
    end

    # GET /notes/:id/edit
    def edit
      # render 'edit'
    end

    # PUT /notes/:id/update
    def update
      # Do not change existing record, create new record and set replaced_by to the new record.
      # check if there are any changes to the note
      if @note[:content] == note_params[:content] || @note[:visible_to_user] == note_params[:visible_to_user]
        redirect_to user_path(@user), notice: 'Nothing to update!'
      else
        unless (@new_note = current_team_member.notes.create!(content: note_params[:content],
                                                              visible_to_user: note_params[:visible_to_user],
                                                              user: @user))
          redirect_to user_path(@user), flash: { error: 'Something went wrong. Please try again.' }
        end
        unless @note.update_column!(:replaced_by, @new_note)
          # delete the new note if we fail to link it to the old note - otherwise, an old 'updated' note will be visible in the main notes list
          @new_note.destroy!
          redirect_to user_path(@user), flash: { error: 'Something went wrong. Please try again.' }
        end
      end
    end

    # DELETE
    def destroy
    end

    private

    def user
      @user = User.find(params[:user_id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: users_path, flash: { error: 'User not found' })
    end

    def note
      @note = current_team_member.notes.find(note_params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: user_path, flash: { error: 'Note not found' })
    end

    def note_params
      params.require(:note).permit(:id, :content, :visible_to_user)
    end
  end
end
