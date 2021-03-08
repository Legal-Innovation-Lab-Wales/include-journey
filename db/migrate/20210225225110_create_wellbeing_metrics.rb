class CreateWellbeingMetrics < ActiveRecord::Migration[6.1]
  def change
    create_table :wellbeing_metrics do |t|
      t.string :name
      t.string :category
      t.belongs_to :team_member, null: false, foreign_key: true

      t.timestamps
    end
  end
end
