module Users
  # app/controllers/users/goals_controller.rb
  class GoalsController < UsersApplicationController
    before_action :goal, only: :achieve

    # GET /goals
    def index
      @goals = current_user.goals

      render 'index'
    end

    # GET /goals/new
    def new
      render 'new'
    end

    # GET /goals/create
    def create
      puts 'Create goal...'
    end

    # PUT /goals/:id/achieve
    def achieve
      puts 'Mark goal as achieved...'
    end

    private

    def goal
      @goal = current_user.goals.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to goals_path, flash: { error: 'No such goal' }
    end
  end
end
