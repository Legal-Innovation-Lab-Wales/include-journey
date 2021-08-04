# db/migrate/20210528104762_create_survey_responses.rb
class CreateSurveyResponses < ActiveRecord::Migration[6.1]
  def change
    create_table :survey_responses do |t|
      t.boolean :submitted, null: false, default: false
      t.belongs_to :survey, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
