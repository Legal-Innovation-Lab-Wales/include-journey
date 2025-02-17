# frozen_string_literal: true

require 'controllers/controller_test'

module TeamMembersControllerTest
  class ContactLogsControllerTest < ControllerTest
    test 'team member can view dashboard' do
      sign_in @team_member
      get authenticated_team_member_root_path
      assert_response :success
    end
  end
end
