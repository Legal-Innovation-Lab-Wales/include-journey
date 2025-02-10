# frozen_string_literal: true

require 'controllers/controller_test'

module TeamMembersControllerTest
  class AppointmentsControllerTest < ControllerTest
    def valid_params
      {
        where: 'The Moon',
        who_with: 'Neil Armstrong',
        what: 'Taking one small step',
        start: '1969-07-21 02:56',
        end: '1969-07-21 05:30',
      }
    end

    test 'team member can create an appointment' do
      sign_in @team_member
      assert_difference 'Appointment.count', 1 do
        post user_appointments_path(@user), params: {appointment: valid_params}
      end

      appointment = Appointment.where(where: 'The Moon').first
      assert_equal @user, appointment.user
      assert_equal @team_member, appointment.team_member
      assert_equal 'Neil Armstrong', appointment.who_with
      assert_equal 'Taking one small step', appointment.what
      assert_equal Time.zone.parse('1969-07-21 02:56'), appointment.start
      assert_equal Time.zone.parse('1969-07-21 05:30'), appointment.end
      assert_not appointment.attended?
    end

    test 'appointment with missing params is not created' do
      sign_in @team_member
      each_missing_param do |params|
        assert_no_difference 'Appointment.count' do
          post user_appointments_path(@user), params: {appointment: params}
        end
      end
    end

    test 'ordinary user cannot create an appointment' do
      sign_in @user
      assert_no_difference 'Appointment.count' do
        post user_appointments_path(@user), params: {appointment: valid_params}
      rescue ActionController::RoutingError
        # do nothing
      end
    end

    test 'team member can toggle an appointment as attended' do
      appointment = appointments :one
      assert_not appointment.attended?

      sign_in @team_member
      assert_no_difference 'Appointment.count' do
        put toggle_attended_user_appointment_path(appointment.user, appointment)
      end

      appointment.reload
      assert appointment.attended?

      assert_no_difference 'Appointment.count' do
        put toggle_attended_user_appointment_path(appointment.user, appointment)
      end

      appointment.reload
      assert_not appointment.attended?
    end

    test 'ordinary user cannot toggle an appointment as attended' do
      appointment = appointments :one
      assert_not appointment.attended?

      sign_in @user
      assert_no_difference 'Appointment.count' do
        put toggle_attended_user_appointment_path(appointment.user, appointment)
      rescue ActionController::RoutingError
        # do nothing
      end

      appointment.reload
      assert_not appointment.attended?
    end
  end
end
