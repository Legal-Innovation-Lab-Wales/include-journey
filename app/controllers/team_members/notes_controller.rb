# frozen_string_literal: true

module TeamMembers
  # app/controllers/team_members/notes_controller.rb
  class NotesController < TeamMembersApplicationController
    before_action :user
    before_action :note, only: :show
    before_action :team_member_note, only: %i[edit update]
    before_action :note_params, only: %i[create update]

    # GET /notes/:id
    def show
      add_breadcrumb('Users', users_path, 'fas fa-user')
      add_breadcrumb(@user.full_name, @user)
      add_breadcrumb('Note', nil, 'fas fa-clipboard-list')
      if @note.replaced_by.present?
        redirect_to user_note_path(@user, @note.latest)
      else
        @user_notes = []
        @note.chain(@user_notes)
      end
    end

    # POST /notes
    def create
      @note = create_note
      if @note.save
        create_message(@note, @user, 'created') if visible_note?
        redirect_to(
          user_path(@user),
          flash: {notice: 'Successfully added note!'},
        )
      else
        error_redirect
      end
    end

    # PUT /notes/:id/update
    def update
      nothing_to_update_redirect and return unless @note.changes?(note_params)

      Note.transaction do
        @new_note = create_note(replacing: @note)
        @note.update!(replaced_by: @new_note)
      end
      update_message(@note, @new_note, user)

      redirect_to(
        user_note_path(@user, @new_note),
        flash: {success: 'Successfully updated note!'},
      )
    rescue ActiveRecord::RecordInvalid
      error_redirect
    end

    # DELETE
    def destroy
      # destroy
    end

    private

    def create_message(note, user, status)
      Message.create!(
        user_id: user.id,
        team_member_id: current_team_member.id,
        note_id: note.id,
        message_status: status,
      )
    end

    def update_message(old_note, new_note, user)
      message = Message.find_by(note_id: old_note.id)
      message&.destroy
      return unless visible_note?

      create_message(new_note, user, 'updated')
    end

    def visible_note?
      case note_params[:visible_to_user]
      when '1'
        true
      when '0'
        false
      end
    end

    def nothing_to_update_redirect
      redirect_to user_path(@user), notice: 'Nothing to update!'
    end

    def error_redirect
      redirect_to(
        user_path(@user),
        flash: {error: 'Something went wrong. Please only use standard characters and punctuation'},
      )
    end

    def create_note(replacing: nil)
      current_team_member.notes.new(
        content: note_params[:content],
        visible_to_user: note_params[:visible_to_user],
        dated: note_params[:dated],
        user: @user,
        replacing: replacing,
      )
    end

    def user
      @user = User.find(params[:user_id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: users_path, flash: {error: 'User not found'})
    end

    def team_member_note
      @note = current_team_member.notes.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: users_path, flash: {error: 'Note not found'})
    end

    def note
      @note = Note.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: users_path, flash: {error: 'Note not found'})
    end

    def note_params
      params.require(:note).permit(:id, :content, :visible_to_user, :dated)
    end
  end
end
