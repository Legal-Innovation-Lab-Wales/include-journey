class CreateCrisisNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :crisis_notes do |t|
      t.text :content
      t.belongs_to :crisis_event, null: false, foreign_key: true
      t.belongs_to :team_member, null: false, foreign_key: true
      t.belongs_to :replaced_by, null: true, foreign_key: { to_table: :crisis_notes }
      t.belongs_to :replacing, null: true, foreign_key: { to_table: :crisis_notes }

      t.timestamps
    end
  end
end
