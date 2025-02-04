# frozen_string_literal: true

class SurveyAnswersUniqueByQuestionAndResponse < ActiveRecord::Migration[6.1]
  def change
    remove_index :survey_answers, [:survey_response_id]
    add_index :survey_answers, [:survey_response_id, :survey_question_id], unique: true, name: 'index_survey_answers_on_response_and_question'

    remove_index :survey_comments, [:survey_response_id]
    add_index :survey_comments, [:survey_response_id, :survey_comment_section_id], unique: true, name: 'index_survey_comments_on_response_and_section'
  end
end
