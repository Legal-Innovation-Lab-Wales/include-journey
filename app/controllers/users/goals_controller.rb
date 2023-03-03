module Users
  # app/controllers/users/goals_controller.rb
  class GoalsController < UsersApplicationController
    before_action :set_breadcrumbs
    before_action :goal, except: %i[index create]

    # GET /goals
    def index
      @goal = Goal.new
      @goals = current_user.goals.includes(:goal_type).unarchived.order(:created_at)
      @has_archived_goals = current_user.goals.archived.present?
      @goal_types = GoalType.all

      render 'index'
    end

    # POST /goals
    def create

      @goal = Goal.new(
        user: current_user,
        goal: goal_params[:goal],
        goal_type_id: goal_params[:goal_type_id] ? goal_params[:goal_type_id] : GoalType.first.id,
        short_term: goal_params[:short_term]
      )

      if @goal.save
        redirect_to goals_path, flash: { success: 'Goal added' }
      else
        redirect_to goals_path, flash: { error: Rails.application.config.text_field_error }
      end

    end

    # PUT /goals/:id/achieve
    def achieve
      if @goal.update!(achieved_on: Time.now)
        redirect_to @goal.archived ? goals_archive_index_path : goals_path, flash: { congratulations: 'Well done!' }
      else
        redirect_to goals_path, flash: { error: 'Goal could not be marked as achieved. Please try again.' }
      end
    end

    # PUT /goals/:id/archive
    def archive
      if @goal.update!(archived: !@goal.archived)
        redirect_to goals_path, flash: { success: "Goal has been #{@goal.archived ? '' : 'un'}archived" }
      else
        redirect_to goals_path, flash: { error: 'Goal could not be archived' }
      end
    end

    # DELETE /goals/:id
    def destroy
      @goal.destroy

      redirect_to goals_path, flash: { success: 'Goal has been deleted' }
    end

    private

    def goal
      @goal = current_user.goals.find(ActiveRecord::Base::sanitize_sql_for_conditions(params[:id]))
    rescue ActiveRecord::RecordNotFound
      redirect_to goals_path, flash: { error: 'No such goal' }
    end

    def goal_params
      params.require(:goal).permit(:goal, :goal_type_id, :short_term)
    end

    def set_breadcrumbs
      path = action_name == 'index' ? nil : goals_path
      add_breadcrumb('My Goals', path, 'fas fa-tasks')
    end
  end
end
