# db/migrate/20210528104755_create_affirmations.rb
class CreateAffirmations < ActiveRecord::Migration[6.1]
  def change
    create_table :affirmations do |t|
      t.string :text, null: false
      t.date :scheduled_date, null: false, index: { unique: true }
      t.belongs_to :team_member, null: false, foreign_key: true

      t.timestamps
    end
  end
end
