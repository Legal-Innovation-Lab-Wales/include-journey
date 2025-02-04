# frozen_string_literal: true

require 'test_helper'

class PriorityTest < ActiveSupport::TestCase
  test 'priority without name is invalid' do
    priority = Priority.new
    assert_invalid priority, :name
  end

  test 'priority with empty name is invalid' do
    priority = Priority.new(name: '')
    assert_invalid priority, :name
  end

  test 'should allow priority with valid name' do
    priority = Priority.new(name: 'Ignore')
    assert_valid priority
    assert_equal 'Ignore', priority.name
  end
end
