# frozen_string_literal: true

require 'test_helper'

class SurveySectionTest < ActiveSupport::TestCase
  fixtures :surveys

  def setup
    super
    @survey = surveys(:onboarding)
  end

  test 'survey section without required fields is invalid' do
    section = SurveySection.new
    assert_invalid section, :survey

    skip 'TODO: currently, this is enforced by a NOT NULL constraint but not ActiveRecord'
    assert_invalid section, :order
  end

  test 'should allow survey section with empty answer labels' do
    section = SurveySection.new(
      survey: @survey,
      answer_labels: '',
      order: 1,
    )
    assert_invalid section, :answer_labels
  end

  test 'should not allow survey section with only one answer label' do
    section = SurveySection.new(
      survey: @survey,
      answer_labels: 'Choice is an illusion',
      order: 1,
    )
    assert_invalid section, :answer_labels
  end

  test 'should not allow survey section with more than six answer labels' do
    section = SurveySection.new(
      survey: @survey,
      answer_labels: 'A;B;C;D;E;F;G',
      order: 1,
    )
    assert_invalid section, :answer_labels
  end

  test 'should not allow survey section with an empty answer label' do
    ['Yes; No; ', ' ; Yes; No', 'Yes; ; No'].each do |answer_labels|
      section = SurveySection.new(
        survey: @survey,
        answer_labels: answer_labels,
        order: 1,
      )
      assert_invalid section, :answer_labels
    end
  end

  test 'should allow survey section with valid fields' do
    section = SurveySection.new(
      survey: @survey,
      answer_labels: 'Yes; No',
      order: 1,
    )

    assert_valid section
    assert_equal @survey, section.survey
    assert_equal 'Yes; No', section.answer_labels
    assert_equal 1, section.order

    assert_equal ['Yes', 'No'], section.answer_labels_array
  end

  test 'all options for answer labels are valid' do
    SurveySection::ANSWER_LABELS_OPTIONS.each do |answer_labels|
      section = SurveySection.new(
        survey: @survey,
        answer_labels: answer_labels,
        order: 1,
      )
      assert_valid section
    end
  end
end
