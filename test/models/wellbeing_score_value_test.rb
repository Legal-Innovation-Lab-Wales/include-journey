# frozen_string_literal: true

require 'test_helper'

class WellbeingScoreValueTest < ActiveSupport::TestCase
  test 'wellbeing-score value without name or color is invalid' do
    skip 'TODO: currently, these fields are not required'

    value = WellbeingScoreValue.new
    assert_invalid value, :name
    assert_invalid value, :color
  end

  test 'wellbeing-score value with empty name is invalid' do
    skip 'TODO: currently, name is not required'

    value = WellbeingScoreValue.new name: ''
    assert_invalid value, :name
  end

  test 'wellbeing-score value without color is invalid' do
    skip 'TODO: currently, color is not required'

    value = WellbeingScoreValue.new name: 'Spiffy'
    assert_invalid value, :color
  end

  test 'wellbeing-score value with empty color is invalid' do
    skip 'TODO: currently, color is not required'

    value = WellbeingScoreValue.new name: 'Spiffy', color: ''
    assert_invalid value, :color
  end

  test 'should allow wellbeing-score value with valid name and color' do
    value = WellbeingScoreValue.new name: 'Spiffy', color: '#001122'
    assert_valid value
    assert_equal 'Spiffy', value.name
    assert_equal '#001122', value.color
  end

  test 'should not allow duplicate wellbeing-score value names' do
    skip 'TODO: currently, uniqueness is not enforced'

    WellbeingScoreValue.create! name: 'Spiffy', color: '#001122'
    value = WellbeingScoreValue.new name: 'Spiffy', color: '#334455'
    assert_invalid value, :name
  end
end
