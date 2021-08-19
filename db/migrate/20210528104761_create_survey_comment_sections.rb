# db/migrate/20210528104761_create_survey_comment_sections.rb
class CreateSurveyCommentSections < ActiveRecord::Migration[6.1]
  def change
    create_table :survey_comment_sections do |t|
      t.text :label, null: false, default: ''
      t.integer :order, null: false
      t.belongs_to :survey_section, null: false, foreign_key: true
      t.integer :total, null: false, default: 0

      t.timestamps
    end
  end
end
