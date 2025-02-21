# frozen_string_literal: true

require 'controllers/controller_test'

module TeamMembersControllerTest
  class ChildFoldersControllerTest < ControllerTest
    test 'team member can view child folders of a folder' do
      clara = users :clara
      folder = folders :one

      sign_in @team_member
      get user_folder_children_path(clara, folder)

      assert_response :success
      assert_match 'Clara Hancock', @response.body
      assert_match 'Some Clara Files', @response.body
      assert_match 'More Clara Files', @response.body
      assert_match 'So Many Clara Files', @response.body
    end

    test 'cannot view child folders for the wrong user' do
      alice = users :alice
      folder = folders :one

      sign_in @team_member
      get user_folder_children_path(alice, folder)

      assert_response :redirect
      refute_match 'Clara Hancock', @response.body
      refute_match 'Some Clara Files', @response.body
      refute_match 'More Clara Files', @response.body
      refute_match 'So Many Clara Files', @response.body
    end

    test 'team member can create a child folder' do
      clara = users :clara
      parent_folder = folders :one
      sign_in @team_member

      assert_difference 'Folder.count', 1 do
        post user_folder_create_child_path(clara, parent_folder), params: {folder: {name: 'Some More Files'}}
      end

      folder = Folder.where(name: 'Some More Files').first
      assert_equal @team_member, folder.team_member
      assert_equal clara, folder.user
      assert_equal parent_folder, folder.parent_folder
    end

    test 'child folder with missing name is not created' do
      clara = users :clara
      parent_folder = folders :one
      sign_in @team_member

      assert_no_difference 'Folder.count' do
        post user_folder_create_child_path(clara, parent_folder), params: {folder: {}}
      rescue ActionController::ParameterMissing
        # do nothing
      end
    end

    test 'child folder for wrong user is not created' do
      alice = users :alice
      parent_folder = folders :one
      sign_in @team_member

      assert_no_difference 'Folder.count' do
        post user_folder_create_child_path(alice, parent_folder), params: {folder: {name: 'Some More Files'}}
      end
    end

    test 'ordinary user cannot create a child folder' do
      clara = users :clara
      parent_folder = folders :one
      sign_in clara

      assert_no_difference 'Folder.count' do
        post user_folder_create_child_path(clara, parent_folder), params: {folder: {}}
      rescue ActionController::RoutingError
        # do nothing
      end
    end
  end
end
