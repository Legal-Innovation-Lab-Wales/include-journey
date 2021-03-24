# app/db/migrate/20210225225111_create_wba_scores.rb
class CreateWbaScores < ActiveRecord::Migration[6.1]
  def change
    create_table :wba_scores do |t|
      t.integer :value
      t.integer :priority
      t.belongs_to :wellbeing_assessment, null: false, foreign_key: true
      t.belongs_to :wellbeing_metric, null: false, foreign_key: true

      t.timestamps
    end
  end
end
