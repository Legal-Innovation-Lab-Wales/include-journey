# frozen_string_literal: true

require 'test_helper'

class GoalTypeTest < ActiveSupport::TestCase
  test 'goal type without name or emoji is invalid' do
    type = GoalType.new
    assert_invalid type, :name
    assert_invalid type, :emoji
  end

  test 'goal type with empty name is invalid' do
    type = GoalType.new(name: '')
    assert_invalid type, :name
  end

  test 'goal type without emoji is invalid' do
    type = GoalType.new(name: 'Wish')
    assert_invalid type, :emoji
  end

  test 'goal type with empty emoji is invalid' do
    type = GoalType.new(name: 'Wish', emoji: '')
    assert_invalid type, :emoji
  end

  test 'should allow goal type with valid name and emoji' do
    type = GoalType.new(name: 'Wish', emoji: ';)')
    assert_valid type
    assert_equal 'Wish', type.name
    assert_equal ';)', type.emoji
  end

  test 'should not allow duplicate goal type names' do
    skip 'TODO: currently, uniqueness is not enforced'

    GoalType.create!(name: 'Wish', emoji: ';)')
    type = GoalType.new(name: 'Wish', emoji: '^_^')
    assert_invalid type, :name
  end
end
