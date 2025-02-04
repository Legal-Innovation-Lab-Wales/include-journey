# frozen_string_literal: true

# db/migrate/20210528104760_create_survey_questions.rb
class CreateSurveyQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :survey_questions do |t|
      t.text :question, null: false, default: ''
      t.integer :order, null: false
      t.belongs_to :survey_section, null: false, foreign_key: true
      t.integer :total, null: false, default: 0
      t.integer :answer0, null: false, default: 0
      t.integer :answer1, null: false, default: 0
      t.integer :answer2, null: false, default: 0
      t.integer :answer3, null: false, default: 0
      t.integer :answer4, null: false, default: 0
      t.integer :answer5, null: false, default: 0

      t.timestamps
    end
  end
end
