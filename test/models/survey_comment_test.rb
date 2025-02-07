# frozen_string_literal: true

require 'test_helper'

class SurveyCommentTest < ActiveSupport::TestCase
  fixtures :users, :surveys, :survey_comment_sections

  def setup
    super
    @user = users(:alice)
    @section = survey_comment_sections(:one)
    @response = SurveyResponse.create!(
      survey: surveys(:onboarding),
      user: @user,
    )
  end

  test 'survey comment without required fields is invalid' do
    comment = SurveyComment.new
    assert_invalid comment, :survey_comment_section
    assert_invalid comment, :survey_response

    skip 'TODO: currently, text is not required'
    assert_invalid comment, :text
  end

  test 'survey comment with empty text is invalid' do
    skip 'TODO: currently, text is not required'

    comment = SurveyComment.new(
      survey_comment_section: @section,
      survey_response: @response,
      text: '',
    )
    assert_invalid comment, :text
  end

  test 'should allow survey comment with valid fields' do
    comment = SurveyComment.new(
      survey_comment_section: @section,
      survey_response: @response,
      text: 'I love apples',
    )

    assert_valid comment
    assert_equal @section, comment.survey_comment_section
    assert_equal @response, comment.survey_response
    assert_equal 'I love apples', comment.text
  end

  test 'survey comments are counted by the section' do
    assert_equal 0, @section.total

    comment = SurveyComment.create!(
      survey_comment_section: @section,
      survey_response: @response,
      text: 'I love apples',
    )
    @section.reload

    assert_equal 1, @section.total

    comment.destroy
    @section.reload

    assert_equal 0, @section.total
  end
end
