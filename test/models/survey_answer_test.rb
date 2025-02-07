# frozen_string_literal: true

require 'test_helper'

class SurveyAnswerTest < ActiveSupport::TestCase
  fixtures :users, :surveys, :survey_sections, :survey_questions

  def setup
    super
    @user = users(:alice)
    @section = survey_sections(:one)
    @question_yn, @question_likert = survey_questions(:s1_q1, :s2_q1)
    @response = SurveyResponse.create!(
      survey: surveys(:onboarding),
      user: @user,
    )
  end

  test 'survey answer without required fields is invalid' do
    answer = SurveyAnswer.new
    assert_invalid answer, :survey_question
    assert_invalid answer, :survey_response
    assert_invalid answer, :answer
  end

  test 'survey answer out of range is invalid' do
    # Likert scale answers are 0..5
    answer = SurveyAnswer.new(
      survey_question: @question_likert,
      survey_response: @response,
      answer: -1,
    )
    assert_invalid answer, :answer

    answer = SurveyAnswer.new(
      survey_question: @question_likert,
      survey_response: @response,
      answer: 6,
    )
    assert_invalid answer, :answer

    # Y/N answers are 0..1
    answer = SurveyAnswer.new(
      survey_question: @question_yn,
      survey_response: @response,
      answer: 2,
    )
    assert_invalid answer, :answer
  end

  test 'survey answer in range is valid' do
    # Likert scale answers are 0..5
    answer = SurveyAnswer.new(
      survey_question: @question_likert,
      survey_response: @response,
      answer: 0,
    )
    assert_valid answer
    answer.destroy

    answer = SurveyAnswer.new(
      survey_question: @question_likert,
      survey_response: @response,
      answer: 5,
    )
    assert_valid answer
    answer.destroy

    # Y/N answers are 0..1
    answer = SurveyAnswer.new(
      survey_question: @question_yn,
      survey_response: @response,
      answer: 0,
    )
    assert_valid answer
    answer.destroy

    answer = SurveyAnswer.new(
      survey_question: @question_yn,
      survey_response: @response,
      answer: 1,
    )
    assert_valid answer
    answer.destroy
  end

  test 'survey answers are counted by the question' do
    assert_equal 0, @question_likert.total
    assert_equal [0, 0, 0, 0, 0, 0], @question_likert.answer_counts

    answer = SurveyAnswer.create!(
      survey_question: @question_likert,
      survey_response: @response,
      answer: 2,
    )
    @question_likert.reload

    assert_equal 1, @question_likert.total
    assert_equal [0, 0, 1, 0, 0, 0], @question_likert.answer_counts

    answer.update!(answer: 4)
    @question_likert.reload

    assert_equal 1, @question_likert.total
    assert_equal [0, 0, 0, 0, 1, 0], @question_likert.answer_counts

    answer.destroy
    @question_likert.reload

    assert_equal 0, @question_likert.total
    assert_equal [0, 0, 0, 0, 0, 0], @question_likert.answer_counts
  end
end
