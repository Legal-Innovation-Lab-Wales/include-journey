module TeamMembers
  # app/controllers/team_members/affirmations_controller.rb
  class AffirmationsController < TeamMembersApplicationController
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

    # PUT /affirmations
    def update

    end

    # DELETE /affirmations
    def destroy

    end
  end
end
