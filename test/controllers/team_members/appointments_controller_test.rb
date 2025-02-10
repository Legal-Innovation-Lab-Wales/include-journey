# frozen_string_literal: true

require 'controllers/controller_test'

module TeamMembersControllerTest
  class AppointmentsControllerTest < ControllerTest
    test 'team member can create an appointment' do
      params = {
        appointment: {
          where: 'The Moon',
          who_with: 'Neil Armstrong',
          what: 'Taking one small step',
          start: '1969-07-21 02:56',
          end: '1969-07-21 05:30',
        },
      }

      sign_in @team_member
      assert_difference 'Appointment.count', 1 do
        post user_appointments_path(@user), params: params
      end

      appointment = Appointment.where(where: 'The Moon').first
      assert_equal @user, appointment.user
      assert_equal @team_member, appointment.team_member
      assert_equal 'Neil Armstrong', appointment.who_with
      assert_equal 'Taking one small step', appointment.what
      assert_equal Time.zone.parse('1969-07-21 02:56'), appointment.start
      assert_equal Time.zone.parse('1969-07-21 05:30'), appointment.end
    end
  end
end
