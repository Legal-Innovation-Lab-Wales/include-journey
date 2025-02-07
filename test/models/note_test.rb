# frozen_string_literal: true

require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  fixtures :team_members, :users, :notes

  def setup
    super
    @team_member = team_members(:barbara)
    @user = users(:bob)
    @time = Time.zone.parse('2021-04-04 12:00')
  end

  test 'note without required fields is invalid' do
    note = Note.new
    assert_invalid note, :team_member
    assert_invalid note, :user
    assert_invalid note, :content
    assert_invalid note, :dated
  end

  test 'note with empty content is invalid' do
    note = Note.new(
      team_member: @team_member,
      user: @user,
      content: '',
      dated: @time,
    )
    assert_invalid note, :content
  end

  test 'should allow note with valid fields' do
    note = Note.new(
      team_member: @team_member,
      user: @user,
      content: 'Very notable indeed',
      dated: @time,
    )

    assert_valid note
    assert_equal @team_member, note.team_member
    assert_equal @user, note.user
    assert_equal 'Very notable indeed', note.content
    assert_equal @time, note.dated
    assert_not note.visible_to_user
  end

  test 'note with one version is latest' do
    note = notes(:one)
    assert_equal note, note.latest
  end

  test 'note with one version has no chain' do
    note = notes(:one)
    assert_equal [note], note.chain
  end

  test 'note with multiple versions has a latest version' do
    note_v1, note_v2, note_v3 = notes(:two_v1, :two_v2, :two_v3)

    assert_equal note_v3, note_v1.latest
    assert_equal note_v3, note_v2.latest
    assert_equal note_v3, note_v3.latest
  end

  test 'note chain includes itself and all notes replaced by it' do
    note_v1, note_v2, note_v3 = notes(:two_v1, :two_v2, :two_v3)

    assert_equal [note_v1], note_v1.chain
    assert_equal [note_v2, note_v1], note_v2.chain
    assert_equal [note_v3, note_v2, note_v1], note_v3.chain
  end

  test 'notes should load by associated team member' do
    assert_equal [notes(:one)], team_members(:alan).notes.all
    assert_equal notes(:two_v1, :two_v2, :two_v3), team_members(:barbara).notes.all
  end

  test 'notes should load by associated user' do
    assert_equal [notes(:one)], users(:alice).notes.all
    assert_equal notes(:two_v1, :two_v2, :two_v3), users(:bob).notes.all
  end
end
