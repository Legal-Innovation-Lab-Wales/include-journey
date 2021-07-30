module TeamMembers
  # app/controllers/team_members/affirmations_controller.rb
  class AffirmationsController < TeamMembersApplicationController
    before_action :affirmation, except: %i[index create]
    before_action :unique_check, only: :update

    # GET /affirmations
    def index
      @affirmations = Affirmation.includes(:team_member)
                                 .where('scheduled_date >= ?', Date.today)
                                 .order(scheduled_date: :asc)

      render 'index'
    end

    # POST /affirmations
    def create

    end

    # GET /affirmations/:id/edit
    def edit
      render 'edit'
    end

    # PUT /affirmations/:id
    def update
      @affirmation.update(
        text: affirmation_params[:text],
        scheduled_date: affirmation_params[:scheduled_date],
        team_member: current_team_member
      )

      redirect_to affirmations_path, flash: { success: 'Daily Affirmation was successfully updated' }
    end

    # DELETE /affirmations/:id
    def destroy
      @affirmation.destroy!

      redirect_to affirmations_path, flash: { success: 'Daily Affirmation was successfully removed' }
    end

    private

    def affirmation
      @affirmation = Affirmation.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: affirmations_path,
                    flash: { error: 'Daily Affirmation not found' })
    end

    def affirmation_params
      params.require(:affirmation).permit(:text, :scheduled_date)
    end

    def unique_check
      date = affirmation_params[:scheduled_date]

      return unless Affirmation.where('id != ? and scheduled_date = ?', @affirmation.id, date).present?

      redirect_back(fallback_location: affirmation_path(@affirmation),
                    flash: { error: "A Daily Affirmation already exists for #{Date.parse(date).strftime('%d/%m/%Y')}" })
    end
  end
end
