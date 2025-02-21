# frozen_string_literal: true

require 'controllers/controller_test'

module TeamMembersControllerTest
  class FoldersControllerTest < ControllerTest
    test 'team member can view folders for a user' do
      alice = users :alice

      sign_in @team_member
      get user_folders_path(alice)

      assert_response :success
      assert_match 'Alice Jones', @response.body
      assert_match 'Alice Files', @response.body
    end

    test 'team member can create a folder' do
      sign_in @team_member

      assert_difference 'Folder.count', 1 do
        post user_folders_path(@user), params: {folder: {name: 'Some More Files'}}
      end

      folder = Folder.where(name: 'Some More Files').first
      assert_equal @team_member, folder.team_member
      assert_equal @user, folder.user
      assert_nil folder.parent_folder
    end

    test 'folder with missing name is not created' do
      sign_in @team_member
      assert_no_difference 'Folder.count' do
        post user_folders_path(@user), params: {folder: {}}
      rescue ActionController::ParameterMissing
        # do nothing
      end
    end

    test 'ordinary user cannot create a folder' do
      sign_in @user
      assert_no_difference 'Folder.count' do
        post user_folders_path(@user), params: {folder: {name: 'Some More Files'}}
      rescue ActionController::RoutingError
        # do nothing
      end
    end

    test 'team member can rename a folder' do
      alice = users :alice
      folder = folders :four

      sign_in @team_member
      assert_no_difference 'Folder.count' do
        put user_folder_path(alice, folder), params: {folder: {name: 'Renamed Alice Files'}}
      end

      folder.reload
      assert_equal @team_member, folder.team_member
      assert_equal alice, folder.user
      assert_equal 'Renamed Alice Files', folder.name
    end

    test 'team member cannot rename a folder belonging to another team member' do
      alice = users :alice
      folder = folders :five

      sign_in @team_member
      assert_no_difference 'Folder.count' do
        put user_folder_path(alice, folder), params: {folder: {name: 'Renamed Alice Files'}}
      end

      folder.reload
      assert_not_equal 'Renamed Alice Files', folder.name
    end

    test 'ordinary user cannot rename a folder' do
      alice = users :alice
      folder = folders :four

      sign_in alice
      assert_no_difference 'Folder.count' do
        put user_folder_path(alice, folder), params: {folder: {name: 'Renamed Alice Files'}}
      rescue ActionController::RoutingError
        # do nothing
      end

      folder.reload
      assert_not_equal 'Renamed Alice Files', folder.name
    end

    test 'team member can delete a folder' do
      alice = users :alice
      folder = folders :four

      sign_in @team_member
      assert_difference 'Folder.count', -1 do
        delete user_folder_path(alice, folder)
      end

      assert_destroyed folder
    end

    test 'team member cannot delete a folder belonging to another team member' do
      alice = users :alice
      folder = folders :five

      sign_in @team_member
      assert_no_difference 'Folder.count' do
        delete user_folder_path(alice, folder)
      end

      assert_not_destroyed folder
    end

    test 'ordinary user cannot delete a folder' do
      alice = users :alice
      folder = folders :five

      sign_in alice
      assert_no_difference 'Folder.count' do
        delete user_folder_path(alice, folder)
      rescue ActionController::RoutingError
        # do nothing
      end

      assert_not_destroyed folder
    end
  end
end
