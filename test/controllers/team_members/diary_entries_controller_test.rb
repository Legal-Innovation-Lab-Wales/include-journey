# frozen_string_literal: true

require 'controllers/controller_test'

module TeamMembersControllerTest
  class DiaryEntriesControllerTest < ControllerTest
    test 'team member can view diary entries index' do
      sign_in @team_member
      get diary_entries_path

      assert_response :success
      assert_match users(:alice).full_name, @response.body
    end

    test 'team member can view diary entry with permission' do
      diary_entry = diary_entries :one
      assert diary_entry.visible_to?(@team_member)
      assert_not diary_entry.viewed_by?(@team_member)

      sign_in @team_member
      get diary_entry_path(diary_entry)

      assert_response :success
      assert_match diary_entry.entry, @response.body
      assert diary_entry.viewed_by?(@team_member)
    end

    test 'team member cannot view diary entry without permission' do
      diary_entry = diary_entries :three
      assert_not diary_entry.visible_to?(@team_member)
      assert_not diary_entry.viewed_by?(@team_member)

      sign_in @team_member
      get diary_entry_path(diary_entry)

      assert_response :redirect
      refute_match diary_entry.entry, @response.body
      assert_not diary_entry.viewed_by?(@team_member)
    end
  end
end
