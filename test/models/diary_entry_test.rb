# frozen_string_literal: true

require 'test_helper'

class DiaryEntryTest < ActiveSupport::TestCase
  fixtures :users, :diary_entries

  def setup
    super
    @user = users(:alice)
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
  end

  test 'diary entries should load by associated user' do
    assert_equal diary_entries(:one, :two), @user.diary_entries.all
  end
end
