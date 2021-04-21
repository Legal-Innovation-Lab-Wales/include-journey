# app/db/migrate/20210225213319_create_notes.rb
class CreateNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :notes do |t|
      t.text :content
      t.boolean :visible_to_user, null: false, default: false
      t.belongs_to :team_member, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.belongs_to :replaced_by, null: true, foreign_key: { to_table: :notes }
      t.belongs_to :replacing, null: true, foreign_key: { to_table: :notes }

      t.timestamps
    end
  end
end
