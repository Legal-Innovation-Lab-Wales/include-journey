# frozen_string_literal: true

require 'test_helper'

class AppointmentTest < ActiveSupport::TestCase
  fixtures :team_members, :users

  def setup
    super
    @team_member = team_members(:barbara)
    @user = users(:alice)
    @start = Time.zone.parse('2021-03-01 15:00')
    @end = Time.zone.parse('2021-03-01 15:30')
  end

  test 'appointment without required fields is invalid' do
    appointment = Appointment.new
    assert_invalid appointment, :user
    assert_invalid appointment, :who_with
    assert_invalid appointment, :where
    assert_invalid appointment, :what
    assert_invalid appointment, :start
    assert_invalid appointment, :end
  end

  test 'appointment with empty required fields is invalid' do
    appointment = Appointment.new(
      who_with: '',
      where: '',
      what: '',
    )
    assert_invalid appointment, :who_with
    assert_invalid appointment, :where
    assert_invalid appointment, :what
  end

  test 'should allow appointment with valid fields' do
    appointment = Appointment.new(
      user: @user,
      who_with: 'A friend',
      where: 'The park',
      what: 'For a hug',
      start: @start,
      end: @end,
    )

    assert_valid appointment
    assert_equal @user, appointment.user
    assert_equal 'A friend', appointment.who_with
    assert_equal 'The park', appointment.where
    assert_equal 'For a hug', appointment.what
    assert_equal @start, appointment.start
    assert_equal @end, appointment.end
    assert_nil appointment.team_member
  end
end
