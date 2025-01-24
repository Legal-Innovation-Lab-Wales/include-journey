require "test_helper"

class SupportEndingReasonTest < ActiveSupport::TestCase
  test "support ending reason without name is invalid" do
    reason = SupportEndingReason.new
    assert_invalid reason, :name
  end

  test "support ending reason with empty name is invalid" do
    reason = SupportEndingReason.new name: ""
    assert_invalid reason, :name
  end

  test "should allow support ending reason with valid name" do
    reason = SupportEndingReason.new name: "No good reason"
    assert_valid reason
    assert_equal "No good reason", reason.name
  end

  test "should not allow duplicate support ending reason names" do
    skip "TODO: currently, uniqueness is not enforced"

    SupportEndingReason.create! name: "No good reason"
    reason = SupportEndingReason.new name: "No good reason"
    assert_invalid reason, :name
  end
end
