# frozen_string_literal: true

require 'test_helper'

class GoalTest < ActiveSupport::TestCase
  fixtures :users, :goals, :goal_types, :achievements

  def setup
    super
    @user = users(:bob)
    @goal_type = goal_types(:hope)
  end

  test 'goal without required fields is invalid' do
    goal = Goal.new
    assert_invalid goal, :user
    assert_invalid goal, :goal
    assert_invalid goal, :goal_type
  end

  test 'should allow goal with valid fields' do
    goal = Goal.new(
      user: @user,
      goal: 'Run 5k',
      goal_type: @goal_type,
    )

    assert_valid goal
    assert_equal @user, goal.user
    assert_equal 'Run 5k', goal.goal
    assert_equal @goal_type, goal.goal_type
  end

  test 'goal should be achievable' do
    goal = Goal.create!(
      user: @user,
      goal: 'Run 5k',
      goal_type: @goal_type,
    )

    assert_not goal.achieved?
    assert_equal 0, @user.goals_achieved_count

    goal.update!(achieved_on: Date.new(2022, 1, 1))

    assert goal.achieved?
    assert_equal 1, @user.goals_achieved_count
  end

  test 'goals should load by associated user' do
    assert_equal goals(:one, :two), users(:alice).goals.all
  end
end
