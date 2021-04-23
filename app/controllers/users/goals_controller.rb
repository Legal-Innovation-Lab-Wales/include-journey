module Users
  # app/controllers/users/goals_controller.rb
  class GoalsController < UsersApplicationController
    before_action :goal, except: %i[index create]

    # GET /goals
    def index
      @goal = Goal.new
      @goals = current_user.goals.includes(:goal_type).order(:created_at)
      @goal_types = GoalType.all

      render 'index'
    end

    # POST /goals
    def create
      if current_user.goals.create!(goal_params)
        redirect_to goals_path, flash: { success: 'Goal added' }
      else
        redirect_to goals_path, flash: { error: 'Goal could not be added' }
      end
    end

    # PUT /goals/:id/achieve
    def achieve
      if @goal.update!(achieved_on: Time.now)
        redirect_to goals_path, flash: { congratulations: 'Well done!' }
      else
        redirect_to goals_path, flash: { error: 'Goal could not be marked as achieved. Please try again.' }
      end
    end

    # PUT /goals/:id/archive
    def archive
      puts 'Archive goal...'
    end

    # DELETE /goals/:id
    def destroy
      @goal.destroy

      redirect_to goals_path, flash: { success: 'Goal has been deleted' }
    end

    private

    def goal
      @goal = current_user.goals.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to goals_path, flash: { error: 'No such goal' }
    end

    def goal_params
      params.require(:goal).permit(:goal, :goal_type_id, :short_term)
    end
  end
end
