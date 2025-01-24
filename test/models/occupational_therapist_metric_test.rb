require "test_helper"

class OccupationalTherapistMetricTest < ActiveSupport::TestCase
  test "occupational therapist metric without name is invalid" do
    metric = OccupationalTherapistMetric.new
    assert_invalid metric, :name
  end

  test "occupational therapist metric with empty name is invalid" do
    metric = OccupationalTherapistMetric.new name: ""
    assert_invalid metric, :name
  end

  test "should allow occupational therapist metric with valid name" do
    metric = OccupationalTherapistMetric.new name: "Grip strength"
    assert_valid metric
    assert_equal "Grip strength", metric.name
  end

  test "should not allow duplicate occupational therapist metric names" do
    skip "TODO: currently, uniqueness is not enforced"

    OccupationalTherapistMetric.create! name: "Grip strength"
    metric = OccupationalTherapistMetric.new name: "Grip strength"
    assert_invalid metric, :name
  end
end
