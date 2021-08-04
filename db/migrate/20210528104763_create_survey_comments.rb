# db/migrate/20210528104763_create_survey_comments.rb
class CreateSurveyComments < ActiveRecord::Migration[6.1]
  def change
    create_table :survey_comments do |t|
      t.text :text, null: false
      t.belongs_to :survey_comment_section, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
