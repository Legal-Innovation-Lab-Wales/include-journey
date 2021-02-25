class CreateWbaSelfScores < ActiveRecord::Migration[6.1]
  def change
    create_table :wba_self_scores do |t|
      t.integer :value
      t.integer :priority
      t.belongs_to :wba_self, null: false, foreign_key: true
      t.belongs_to :wellbeing_metric, null: false, foreign_key: true

      t.timestamps
    end
  end
end
