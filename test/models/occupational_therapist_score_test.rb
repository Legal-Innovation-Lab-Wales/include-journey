require "test_helper"

class OccupationalTherapistScoreTest < ActiveSupport::TestCase
  test "occupational therapist score without value is invalid" do
    score = OccupationalTherapistScore.new
    assert_invalid score, :value
  end

  test "occupational therapist score with empty value is invalid" do
    score = OccupationalTherapistScore.new value: ""
    assert_invalid score, :value
  end

  test "occupational therapist score with value outside of allowed list is invalid" do
    score = OccupationalTherapistScore.new value: "Mu"
    assert_invalid score, :value
  end

  test "should allow occupational therapist score with valid value" do
    score = OccupationalTherapistScore.new value: "3"
    assert_valid score
    assert_equal "3", score.value
  end
end
