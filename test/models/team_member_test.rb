# frozen_string_literal: true

require 'test_helper'

class TeamMemberTest < ActiveSupport::TestCase
  test 'team member without required fields is invalid' do
    team_member = TeamMember.new

    assert_invalid team_member, :first_name
    assert_invalid team_member, :last_name
    assert_invalid team_member, :email
    assert_invalid team_member, :mobile_number
    assert_invalid team_member, :password
  end

  test 'team member with empty required fields is invalid' do
    team_member = TeamMember.new(
      first_name: '',
      last_name: '',
      email: '',
      password: '',
      mobile_number: '',
    )

    assert_invalid team_member, :first_name
    assert_invalid team_member, :last_name
    assert_invalid team_member, :email
    assert_invalid team_member, :mobile_number
    assert_invalid team_member, :password
  end

  test 'team member not accepting terms is invalid' do
    team_member = TeamMember.new(
      first_name: 'Clive',
      last_name: 'Doe',
      email: 'clive.doe@example.com',
      mobile_number: '07567 890123',
      password: 'test1234',
    )

    assert_invalid team_member, :terms
  end

  test 'team member with required fields, accepting terms, is valid' do
    team_member = TeamMember.new(
      first_name: 'Clive',
      last_name: 'Doe',
      email: 'clive.doe@example.com',
      mobile_number: '07567 890123',
      password: 'test1234',
      terms: true,
    )
    team_member.skip_confirmation!

    assert_valid team_member
    assert_equal 'Clive', team_member.first_name
    assert_equal 'Doe', team_member.last_name
    assert_equal 'clive.doe@example.com', team_member.email
  end
end
