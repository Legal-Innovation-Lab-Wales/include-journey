require "test_helper"

class AchievementTest < ActiveSupport::TestCase
  test "achievement without required fields is invalid" do
    achievement = Achievement.new

    assert_invalid achievement, :name
    assert_invalid achievement, :description
    assert_invalid achievement, :entities
  end

  test "achievement with empty required fields is invalid" do
    achievement = Achievement.new name: "", description: "", entities: ""

    assert_invalid achievement, :name
    assert_invalid achievement, :description
    assert_invalid achievement, :entities
  end

  test "achievement with required fields is valid" do
    # Model checks for presence of bronze_count, silver_count, gold_count, but
    # these have default values of 0 so they are always present anyway.
    # Probably they shouldn't have default values, as nowhere in the code uses
    # those defaults.
    achievement = Achievement.new name: "Session Seeker", description: "You attended enough sessions.", entities: "sessions",
                                  bronze_count: 10, silver_count: 20, gold_count: 50
    
    assert_valid achievement
    assert_equal "Session Seeker", achievement.name
    assert_equal "You attended enough sessions.", achievement.description
    assert_equal "sessions", achievement.entities
    assert_equal 10, achievement.bronze_count
    assert_equal 20, achievement.silver_count
    assert_equal 50, achievement.gold_count
  end
end
