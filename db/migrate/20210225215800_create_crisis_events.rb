class CreateCrisisEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :crisis_events do |t|
      t.text :additional_info
      t.boolean :closed
      t.integer :closed_by
      t.datetime :closed_at
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :crisis_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
