# frozen_string_literal: true

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
        goal_type_id: goal_params[:goal_type_id] || GoalType.first.id,
        short_term: goal_params[:short_term],
      )

      flash = if @goal.save
        {success: 'Goal added'}
      else
        {error: Rails.application.config.text_field_error}
      end
      redirect_to goals_path, flash: flash
    end

    # PUT /goals/:id/achieve
    def achieve
      if @goal.update!(achieved_on: Time.current)
        redirect_to(
          @goal.archived ? goals_archive_index_path : goals_path,
          flash: {congratulations: 'Well done!'},
        )
      else
        redirect_to(
          goals_path,
          flash: {error: 'Goal could not be marked as achieved. Please try again.'},
        )
      end
    end

    # PUT /goals/:id/archive
    def archive
      flash = if @goal.update!(archived: !@goal.archived)
        {success: "Goal has been #{@goal.archived ? '' : 'un'}archived"}
      else
        {error: 'Goal could not be archived'}
      end
      redirect_to goals_path, flash: flash
    end

    # DELETE /goals/:id
    def destroy
      @goal.destroy

      redirect_to goals_path, flash: {success: 'Goal has been deleted'}
    end

    private

    def goal
      @goal = current_user.goals.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to goals_path, flash: {error: 'No such goal'}
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
