# db/migrate/20210528104760_create_survey_questions.rb
class CreateSurveyQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :survey_questions do |t|
      t.text :question, null: false
      t.integer :order, null: false
      t.belongs_to :survey_section, null: false, foreign_key: true

      t.timestamps
    end
  end
end
