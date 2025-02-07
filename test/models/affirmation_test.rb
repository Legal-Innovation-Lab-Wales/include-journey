# frozen_string_literal: true

require 'test_helper'

class AffirmationTest < ActiveSupport::TestCase
  fixtures :team_members

  def setup
    super
    @date = Date.new(2020, 1, 12)
    @team_member = team_members(:barbara)
  end

  test 'affirmation without required fields is invalid' do
    affirmation = Affirmation.new
    assert_invalid affirmation, :text
    assert_invalid affirmation, :scheduled_date
    assert_invalid affirmation, :team_member
  end

  test 'affirmation with empty text is invalid' do
    affirmation = Affirmation.new(text: '')
    assert_invalid affirmation, :text
  end

  test 'should allow affirmation with valid fields' do
    affirmation = Affirmation.new(
      text: 'All is well',
      scheduled_date: @date,
      team_member: @team_member,
    )

    assert_valid affirmation
    assert_equal 'All is well', affirmation.text
    assert_equal @date, affirmation.scheduled_date
    assert_equal @team_member, affirmation.team_member
  end

  test 'should not allow multiple affirmations on same date' do
    skip 'TODO: currently, this is enforced by a unique index but not ActiveRecord'

    Affirmation.create!(
      text: 'All is well',
      scheduled_date: @date,
      team_member: @team_member,
    )

    affirmation = Affirmation.new(
      text: 'Everything is fine',
      scheduled_date: @date,
      team_member: @team_member,
    )
    assert_invalid affirmation, :date
  end
end
