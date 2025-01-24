require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "user without required fields is invalid" do
    user = User.new

    assert_invalid user, :first_name
    assert_invalid user, :last_name
    assert_invalid user, :email
    assert_invalid user, :password
  end

  test "user with empty required fields is invalid" do
    user = User.new first_name: "", last_name: "", email: "", password: ""

    assert_invalid user, :first_name
    assert_invalid user, :last_name
    assert_invalid user, :email
    assert_invalid user, :password
  end

  test "user not accepting terms is invalid" do
    user = User.new first_name: "Clive", last_name: "Doe", email: "clive.doe@example.com", password: "test1234"

    assert_invalid user, :terms
  end

  test "user with required fields, accepting terms, is valid" do
    user = User.new first_name: "Clive", last_name: "Doe", email: "clive.doe@example.com", password: "test1234", terms: true

    assert_valid user
    assert_equal "Clive", user.first_name
    assert_equal "Doe", user.last_name
    assert_equal "clive.doe@example.com", user.email
  end

  test "user with out-of-list values for optional fields is invalid" do
    user = User.new first_name: "Clive", last_name: "Doe", email: "clive.doe@example.com", password: "test1234", terms: true,
                    ethnic_group: "Clown", religion: "McDonalds", sex: "Burger", gender_identity: "Big Mac", pronouns: "Grimace/Grimace"
    
    assert_invalid user, :ethnic_group
    assert_invalid user, :religion
    assert_invalid user, :sex
    assert_invalid user, :gender_identity
    assert_invalid user, :pronouns
  end

  test "user with in-list values for optional fields is valid" do
    user = User.new first_name: "Clive", last_name: "Doe", email: "clive.doe@example.com", password: "test1234", terms: true,
                    ethnic_group: "White: Other", religion: "Christian", sex: "Male", gender_identity: "Yes", pronouns: "He/Him"
    
    assert_valid user
    assert_equal "White: Other", user.ethnic_group
    assert_equal "Christian", user.religion
    assert_equal "Male", user.sex
    assert_equal "Yes", user.gender_identity
    assert_equal "He/Him", user.pronouns
  end
end
