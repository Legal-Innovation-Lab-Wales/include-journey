# frozen_string_literal: true

require 'test_helper'

class AchievementTest < ActiveSupport::TestCase
  fixtures :achievements, :users

  test 'achievement without required fields is invalid' do
    achievement = Achievement.new

    assert_invalid achievement, :name
    assert_invalid achievement, :description
    assert_invalid achievement, :entities
  end

  test 'achievement with empty required fields is invalid' do
    achievement = Achievement.new(
      name: '',
      description: '',
      entities: '',
    )

    assert_invalid achievement, :name
    assert_invalid achievement, :description
    assert_invalid achievement, :entities
  end

  test 'achievement with required fields is valid' do
    # Model checks for presence of bronze_count, silver_count, gold_count, but
    # these have default values of 0 so they are always present anyway.
    # Probably they shouldn't have default values, as nowhere in the code uses
    # those defaults.
    achievement = Achievement.new(
      name: 'Session Seeker',
      description: 'You attended enough sessions.',
      entities: 'sessions',
      bronze_count: 10,
      silver_count: 20,
      gold_count: 50,
    )

    assert_valid achievement
    assert_equal 'Session Seeker', achievement.name
    assert_equal 'You attended enough sessions.', achievement.description
    assert_equal 'sessions', achievement.entities
    assert_equal 10, achievement.bronze_count
    assert_equal 20, achievement.silver_count
    assert_equal 50, achievement.gold_count
  end

  test 'user has all-time achievement medals after correct number of sessions' do
    # Achievement for number of sessions
    achievement = achievements(:familiar_face)
    user = users(:alice)
    a = achievement.user_achievements.find_or_create_by!(user: user)

    # achievement.check mutates the user_achievement in the database, so must reload
    achievement.check(user)
    a.reload
    assert_equal [false, false, false], [a.bronze_achieved, a.silver_achieved, a.gold_achieved]

    # No medals after 99 sessions
    add_sessions(user, nil, 0...99)
    achievement.check(user)
    a.reload
    assert_equal [false, false, false], [a.bronze_achieved, a.silver_achieved, a.gold_achieved]

    # Bronze after 100 sessions
    add_sessions(user, nil, 99...100)
    achievement.check(user)
    a.reload
    assert_equal [true, false, false], [a.bronze_achieved, a.silver_achieved, a.gold_achieved]

    # No silver after 249 sessions
    add_sessions(user, nil, 100...249)
    achievement.check(user)
    a.reload
    assert_equal [true, false, false], [a.bronze_achieved, a.silver_achieved, a.gold_achieved]

    # Silver after 250 sessions
    add_sessions(user, nil, 249...250)
    achievement.check(user)
    a.reload
    assert_equal [true, true, false], [a.bronze_achieved, a.silver_achieved, a.gold_achieved]

    # No gold after 499 sessions
    add_sessions(user, nil, 250...499)
    achievement.check(user)
    a.reload
    assert_equal [true, true, false], [a.bronze_achieved, a.silver_achieved, a.gold_achieved]

    # Gold after 500 sessions
    add_sessions(user, nil, 499...500)
    achievement.check(user)
    a.reload
    assert_equal [true, true, true], [a.bronze_achieved, a.silver_achieved, a.gold_achieved]
  end

  test 'user has monthly achievement medals after correct number of sessions within date range' do
    # Achievement for number of sessions
    achievement = achievements(:familiar_face_jan)
    user = users(:alice)
    a = achievement.user_achievements.find_or_create_by!(user: user)

    # achievement.check mutates the user_achievement in the database, so must reload
    achievement.check(user)
    a.reload
    assert_equal [false, false, false], [a.bronze_achieved, a.silver_achieved, a.gold_achieved]

    # No medals after 9 sessions
    add_sessions(user, achievement.starts_at, 0...9)
    achievement.check(user)
    a.reload
    assert_equal [false, false, false], [a.bronze_achieved, a.silver_achieved, a.gold_achieved]

    # Bronze after 10 sessions
    add_sessions(user, achievement.starts_at, 9...10)
    achievement.check(user)
    a.reload
    assert_equal [true, false, false], [a.bronze_achieved, a.silver_achieved, a.gold_achieved]

    # No silver after 19 sessions
    add_sessions(user, achievement.starts_at, 10...19)
    achievement.check(user)
    a.reload
    assert_equal [true, false, false], [a.bronze_achieved, a.silver_achieved, a.gold_achieved]

    # Silver after 20 sessions
    add_sessions(user, achievement.starts_at, 19...20)
    achievement.check(user)
    a.reload
    assert_equal [true, true, false], [a.bronze_achieved, a.silver_achieved, a.gold_achieved]

    # No gold after 30 sessions
    add_sessions(user, achievement.starts_at, 20...30)
    achievement.check(user)
    a.reload
    assert_equal [true, true, false], [a.bronze_achieved, a.silver_achieved, a.gold_achieved]

    # Gold after 31 sessions
    add_sessions(user, achievement.starts_at, 30...31)
    achievement.check(user)
    a.reload
    assert_equal [true, true, true], [a.bronze_achieved, a.silver_achieved, a.gold_achieved]
  end

  test 'user is not awarded monthly achievement medals for sessions outside of date range' do
    skip 'TODO: this is currently not implemented correctly'

    # Achievement for number of sessions
    achievement = achievements(:familiar_face_jan)
    user = users(:alice)
    a = achievement.user_achievements.find_or_create_by!(user: user)

    add_sessions(user, achievement.starts_at - 1.year, 0...31)
    achievement.check(user)
    a.reload
    assert_equal [false, false, false], [a.bronze_achieved, a.silver_achieved, a.gold_achieved]
  end

  private

  def add_sessions(user, start_at, indices)
    start_at ||= Date.new(2020, 1, 1)
    Session.create(indices.map do |index|
      {user: user, session_at: start_at + index.days}
    end)
  end
end
