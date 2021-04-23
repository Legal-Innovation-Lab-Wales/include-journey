module TeamMembers
  # app/controllers/team_members/notes_controller.rb
  class NotesController < TeamMembersApplicationController
    before_action :user
    before_action :note, only: :show
    before_action :team_member_note, only: %i[edit update]
    before_action :note_params, only: %i[create update]

    # POST /notes
    def create
      if (@note = create_note)
        redirect_to user_path(@user), notice: { flash: 'Successfully added note!' }
      else
        error_redirect
      end
    end

    # GET /notes/:id
    def show
      if @note.replaced_by.present?
        redirect_to user_note_path(@user, @note.latest)
      else
        @user_notes = []
        @note.chain(@user_notes)
      end
    end

    # PUT /notes/:id/update
    def update
      nothing_to_update_redirect and return unless @note.changes?(note_params)

      ActiveRecord::Base.transaction do
        @new_note = create_note(replacing: @note)
        @note.update!(replaced_by: @new_note)
      end

      redirect_to user_note_path(@user, @new_note), flash: { success: 'Successfully updated note!' }
    rescue ActiveRecord::RecordInvalid
      error_redirect
    end

    # DELETE
    def destroy
      # destroy
    end

    private

    def nothing_to_update_redirect
      redirect_to user_path(@user), notice: 'Nothing to update!'
    end

    def error_redirect
      redirect_to user_path(@user), flash: { error: 'Something went wrong. Please try again.' }
    end

    def create_note(replacing: nil)
      current_team_member.notes.create!(content: note_params[:content],
                                        visible_to_user: note_params[:visible_to_user],
                                        user: @user,
                                        replacing: replacing)
    end

    def user
      @user = User.find(params[:user_id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: users_path, flash: { error: 'User not found' })
    end

    def team_member_note
      @note = current_team_member.notes.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: users_path, flash: { error: 'Note not found' })
    end

    def note
      @note = Note.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: users_path, flash: { error: 'Note not found' })
    end

    def note_params
      params.require(:note).permit(:id, :content, :visible_to_user)
    end
  end
end
