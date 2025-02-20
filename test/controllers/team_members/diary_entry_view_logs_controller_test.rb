# frozen_string_literal: true

require 'controllers/controller_test'

module TeamMembersControllerTest
  class DiaryEntryViewLogsControllerTest < ControllerTest
    test 'admin can view diary-entry-view-logs for themselves' do
      sign_in @admin
      get team_member_diary_entry_view_logs_path(@admin)

      assert_response :success
      assert_match 'Alice Jones', @response.body
      assert_match 'Bob Smith', @response.body
    end

    test 'admin can view diary-entry-view-logs for another team member' do
      sign_in @admin
      get team_member_diary_entry_view_logs_path(@team_member)

      assert_response :success
      assert_match 'Alice Jones', @response.body
      refute_match 'Bob Smith', @response.body
    end

    test 'team_member cannot view diary-entry-view-logs' do
      sign_in @team_member
      get team_member_diary_entry_view_logs_path(@team_member)

      assert_response :redirect
      refute_match 'Alice Jones', @response.body
      refute_match 'Bob Smith', @response.body
    end
  end
end
