class NotesController < ApplicationController
  before_action :set_note, only: %i[ show edit update destroy ]
  before_action :note_params, only: :create

  # GET /notes or /notes.json
  def index
    @notes = Note.all
  end

  # GET /notes/1 or /notes/1.json
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes or /notes.json
  def create
    @note = Note.create!({ content: note_params[:content],
                           visible_to_user: note_params[:visible_to_user],
                           user_id: params[:user_id],
                           team_member_id: current_team_member.id
                         })
    if @note
      redirect_to user_path(params[:user_id]), notice: "Note added!"
    else
      redirect_to user_path(params[:user_id]), notice: "We couldn't create the note. Please try again."
    end
  end

  # PATCH/PUT /notes/1 or /notes/1.json
  def update

    if @note.update!(note_params)
      redirect_to user_path(params[:user_id]), notice: "Note updated!"
    else
      redirect_to user_path(params[:user_id]), notice: "We couldn't create the note. Please try again."
    end
  end

  # DELETE /notes/1 or /notes/1.json
  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to notes_url, notice: "Note was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_note
    @note = Note.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  #
  def note_params
    params.require(:note).permit(:content, :visible_to_user)
  end
end
