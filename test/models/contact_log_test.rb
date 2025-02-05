# frozen_string_literal: true

require 'test_helper'

class ContactLogTest < ActiveSupport::TestCase
  fixtures :team_members, :users, :contact_types, :contact_purposes, :contact_logs

  def setup
    super
    @team_member = team_members(:barbara)
    @user = users(:alice)
    @contact_type = contact_types(:scheduled)
    @contact_purpose = contact_purposes(:one_to_one)
    @start = Time.zone.parse('2021-03-03 12:30')
    @end = Time.zone.parse('2021-03-03 12:50')
  end

  test 'contact log without required fields is invalid' do
    contact_log = ContactLog.new
    assert_invalid contact_log, :user
    assert_invalid contact_log, :team_member
    assert_invalid contact_log, :contact_type
    assert_invalid contact_log, :contact_purpose
    assert_invalid contact_log, :start
    assert_invalid contact_log, :end
  end

  test 'should allow contact log with valid fields' do
    contact_log = ContactLog.new(
      user: @user,
      team_member: @team_member,
      contact_type: @contact_type,
      contact_purpose: @contact_purpose,
      start: @start,
      end: @end,
    )

    assert_valid contact_log
    assert_equal @user, contact_log.user
    assert_equal @team_member, contact_log.team_member
    assert_equal @contact_type, contact_log.contact_type
    assert_equal @contact_purpose, contact_log.contact_purpose
    assert_nil contact_log.notes
    assert_equal @start, contact_log.start
    assert_equal @end, contact_log.end
  end

  test 'contact logs should load by associated user' do
    assert_equal contact_logs(:one, :two), @user.contact_logs.all
  end

  test 'contact logs should load by associated team member' do
    assert_equal contact_logs(:one, :two), @team_member.contact_logs.all
  end
end
