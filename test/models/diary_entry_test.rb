# frozen_string_literal: true

require 'test_helper'

class DiaryEntryTest < ActiveSupport::TestCase
  fixtures :team_members, :users, :diary_entries, :diary_entry_permissions

  def setup
    super
    @user = users(:alice)
    @team_member = team_members(:barbara)
    @time = Time.zone.parse('2021-03-03 12:30')
  end

  test 'diary entry without required fields is invalid' do
    # TODO: should entry and created_at also be required?
    entry = DiaryEntry.new
    assert_invalid entry, :user
    assert_invalid entry, :feeling
  end

  test 'should allow diary entry with valid fields' do
    entry = DiaryEntry.new(
      user: @user,
      entry: 'Things are fine',
      feeling: '😊',
      created_at: @time,
    )

    assert_valid entry
    assert_equal @user, entry.user
    assert_equal 'Things are fine', entry.entry
    assert_equal '😊', entry.feeling
    assert_equal @time, entry.created_at
    assert_not entry.visible_to?(@team_member)
    assert_not entry.viewed_by?(@team_member)
  end

  test 'entry with permission should be visible to team member' do
    entry = DiaryEntry.create!(
      user: @user,
      entry: 'Things are fine',
      feeling: '😊',
      created_at: @time,
    )
    entry.give_permission(@team_member)

    assert entry.visible_to?(@team_member)
    assert_not entry.viewed_by?(@team_member)
  end

  test 'entry should be marked as viewed by team member' do
    entry = DiaryEntry.create!(
      user: @user,
      entry: 'Things are fine',
      feeling: '😊',
      created_at: @time,
    )
    entry.give_permission(@team_member)
    entry.log_view(@team_member)

    assert entry.viewed_by?(@team_member)
  end

  test 'diary entries should load by associated user' do
    assert_equal diary_entries(:one, :two, :three), @user.diary_entries.all
  end

  test 'diary entries with permission should load by team member' do
    assert_equal diary_entries(:one, :two), @team_member.diary_entries.all
  end
end
