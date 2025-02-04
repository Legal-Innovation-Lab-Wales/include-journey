# frozen_string_literal: true

# db/migrate/20210528104764_create_survey_comments.rb
class CreateSurveyComments < ActiveRecord::Migration[6.1]
  def change
    create_table :survey_comments do |t|
      t.text :text
      t.belongs_to :survey_comment_section, null: false, foreign_key: true
      t.belongs_to :survey_response, null: false, foreign_key: true

      t.timestamps
    end
  end
end
