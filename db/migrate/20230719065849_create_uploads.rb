class CreateUploads < ActiveRecord::Migration[6.1]
  def change
    create_table :uploads do |t|
      t.text :comment
      t.string :status, default: 'pending'
      t.string :added_by
      t.bigint :added_by_id
      t.string :approved_by
      t.datetime :approved_at
      t.boolean :visible_to_user, default: true
      t.references :user, null: false, foreign_key: true
      t.references :team_member, foreign_key: true, index: true, optional: true

      t.timestamps
    end
  end
end
