# db/migrate/20210528104762_create_survey_answers.rb
class CreateSurveyAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :survey_answers do |t|
      t.integer :answer, null: false
      t.belongs_to :survey_question, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
