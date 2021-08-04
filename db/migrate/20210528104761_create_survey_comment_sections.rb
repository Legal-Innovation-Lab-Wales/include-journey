# db/migrate/20210528104761_create_survey_comment_sections.rb
class CreateSurveyCommentSections < ActiveRecord::Migration[6.1]
  def change
    create_table :survey_comment_sections do |t|
      t.text :label, null: false
      t.integer :order, null: false
      t.belongs_to :survey_section, null: false, foreign_key: true

      t.timestamps
    end
  end
end
