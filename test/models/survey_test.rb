# frozen_string_literal: true

require 'test_helper'

class SurveyTest < ActiveSupport::TestCase
  fixtures :team_members

  def setup
    super
    @start_date = Date.new(2020, 1, 1)
    @end_date = Date.new(2021, 1, 1)
    @team_member = team_members(:barbara)
  end

  test 'survey without required fields is invalid' do
    survey = Survey.new
    assert_invalid survey, :name
    assert_invalid survey, :start_date
    assert_invalid survey, :end_date
    assert_invalid survey, :team_member
  end

  test 'survey with empty name is invalid' do
    survey = Survey.new(name: '')
    assert_invalid survey, :name
  end

  test 'should allow survey with valid fields' do
    survey = Survey.new(
      name: 'Rate Your Experience',
      start_date: @start_date,
      end_date: @end_date,
      team_member: @team_member,
    )

    assert_valid survey
    assert_equal 'Rate Your Experience', survey.name
    assert_equal @start_date, survey.start_date
    assert_equal @end_date, survey.end_date
    assert_equal @team_member, survey.team_member
  end

  test 'should not allow survey with start date after end date' do
    skip 'TODO: this is currently not enforced'

    survey = Survey.new(
      name: 'Rate Your Experience',
      start_date: @end_date,
      end_date: @start_date,
      team_member: @team_member,
    )

    assert_invalid survey, :start_date
  end
end
