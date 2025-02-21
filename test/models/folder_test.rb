# frozen_string_literal: true

require 'test_helper'

class FolderTest < ActiveSupport::TestCase
  fixtures :team_members, :users, :folders

  def setup
    @team_member = team_members(:barbara)
    @user = users(:bob)
  end

  test 'folder without required fields is invalid' do
    folder = Folder.new
    assert_invalid folder, :team_member
    assert_invalid folder, :name
  end

  test 'should allow folder with valid fields' do
    folder = Folder.new(team_member: @team_member, name: 'My Documents')

    assert_valid folder
    assert_equal @team_member, folder.team_member
    assert_equal 'My Documents', folder.name
    assert_nil folder.user
    assert_nil folder.parent_folder
  end

  test 'folders should load by associated team member' do
    alan, barbara = team_members(:alan, :barbara)
    assert_equal folders(:one, :two, :three, :four), barbara.folders.all
    assert_equal folders(:five, :six), alan.folders.all
  end

  test 'folders should load by associated user' do
    alice, bob = users(:alice, :bob)
    assert_equal folders(:four, :five), alice.folders.all
    assert_equal [folders(:six)], bob.folders.all
  end

  test 'folders should load by parent folder' do
    one, two, three = folders(:one, :two, :three)
    assert_equal one, two.parent_folder
    assert_equal one, three.parent_folder
    assert_equal [two, three], one.child_folders.all
    assert_equal [], two.child_folders.all
    assert_equal [], three.child_folders.all
  end
end
