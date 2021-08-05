# db/migrate/20210528104762_create_survey_responses.rb
class CreateSurveyResponses < ActiveRecord::Migration[6.1]
  def change
    create_table :survey_responses do |t|
      t.datetime :submitted_at
      t.belongs_to :survey, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
