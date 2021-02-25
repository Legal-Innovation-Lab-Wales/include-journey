class CreateCrisisTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :crisis_types do |t|
      t.string :type
      t.belongs_to :team_member, null: false, foreign_key: true

      t.timestamps
    end
  end
end
