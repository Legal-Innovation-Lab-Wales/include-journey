class CreateUploads < ActiveRecord::Migration[6.1]
  def change
    create_table :uploads do |t|
      t.text :comment
      t.string :status
      t.string :approved_by
      t.datetime :approved_at
      t.string :added_by
      t.references :uploadable, null: false, foreign_key: true

      t.timestamps
    end
  end
end
