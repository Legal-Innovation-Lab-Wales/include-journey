# frozen_string_literal: true

require 'controllers/controller_test'

module TeamMembersControllerTest
  class AffirmationsArchiveControllerTest < ControllerTest
    test 'team member can view affirmations archive' do
      sign_in @team_member
      get affirmations_archive_index_path

      assert_response :success
      assert_match 'You are awesome!', @response.body
      assert_match 'Everything is great!', @response.body
    end

    test 'team member can search affirmations archive' do
      sign_in @team_member
      get affirmations_archive_index_path, params: {query: 'awesome'}

      assert_response :success
      assert_match 'You are awesome!', @response.body
      assert_no_match 'Everything is great!', @response.body
    end

    test 'ordinary user cannot view affirmations archive' do
      sign_in @user
      get affirmations_archive_index_path

      assert_response :redirect
    end
  end
end
