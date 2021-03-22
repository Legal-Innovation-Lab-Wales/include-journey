module TeamMembers
  # app/controllers/team_members/users_controller.rb
  class UsersController < TeamMembersApplicationController
    # need to add before_action :is_team_member? or similar
    before_action :user, :user_location, :note, :user_notes, :wba_self, :wellbeing_metrics, :journal_entries, only: :show

    def show
      render 'show'
    end

    private

    def note
      @note = Note.new
    end

    def user
      @user = User.includes(:notes).find(params[:id])
    end

    def user_notes
      @user_notes = @user.notes.order(created_at: :desc)
    end

    def user_location
      @user_location = @user.last_sign_in_ip
    end

    def wellbeing_metrics
      @wellbeing_metrics = WellbeingMetric.all
    end

    def wba_self
      @wba_self = WbaSelf.includes(:wba_self_scores).find(params[:id])
    rescue ActiveRecord::RecordNotFound
      session notice: 'No wellbeing assessment could be found'
    end

    def journal_entries
      @journal_entries = @user.journal_entries
    end
  end
end
