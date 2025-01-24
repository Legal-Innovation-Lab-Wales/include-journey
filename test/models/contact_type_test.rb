require "test_helper"

class ContactTypeTest < ActiveSupport::TestCase
  test "contact type without name or color is invalid" do
    type = ContactType.new
    assert_invalid type, :name
    # TODO: currently, color is not required
    #assert_invalid type, :color
  end

  test "contact type with empty name is invalid" do
    type = ContactType.new name: ""
    assert_invalid type, :name
  end

  test "contact type without color is invalid" do
    skip "TODO: currently, color is not required"

    type = ContactType.new name: "Smoke signals"
    assert_invalid type, :color
  end

  test "contact type with empty color is invalid" do
    skip "TODO: currently, color is not required"

    type = ContactType.new name: "Smoke signals", color: ""
    assert_invalid type, :color
  end

  test "should allow contact type with valid name and color" do
    type = ContactType.new name: "Smoke signals", color: "#001122"
    assert_valid type
    assert_equal "Smoke signals", type.name
    assert_equal "#001122", type.color
  end

  test "should not allow duplicate contact type names" do
    skip "TODO: currently, uniqueness is not enforced"

    ContactType.create! name: "Smoke signals", color: "#001122"
    type = ContactType.new name: "Smoke signals", color: "#334455"
    assert_invalid type, :name
  end
end
