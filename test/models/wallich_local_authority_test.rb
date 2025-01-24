require "test_helper"

class WallichLocalAuthorityTest < ActiveSupport::TestCase
  test "local authority without name is invalid" do
    authority = WallichLocalAuthority.new
    assert_invalid authority, :name
  end

  test "local authority with empty name is invalid" do
    authority = WallichLocalAuthority.new name: ""
    assert_invalid authority, :name
  end

  test "should allow local authority with valid name" do
    authority = WallichLocalAuthority.new name: "Springfield"
    assert_valid authority
    assert_equal "Springfield", authority.name
  end

  test "should not allow duplicate local authority names" do
    skip "TODO: currently, uniqueness is not enforced"

    WallichLocalAuthority.create! name: "Springfield"
    authority = WallichLocalAuthority.new name: "Springfield"
    assert_invalid authority, :name
  end
end
