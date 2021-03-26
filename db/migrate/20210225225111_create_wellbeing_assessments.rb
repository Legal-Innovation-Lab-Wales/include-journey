# app/db/migrate/20210225225111_create_wellbeing_assessments.rb
class CreateWellbeingAssessments < ActiveRecord::Migration[6.1]
  def change
    create_table :wellbeing_assessments do |t|
      t.belongs_to :team_member, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
