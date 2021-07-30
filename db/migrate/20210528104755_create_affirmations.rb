# db/migrate/20210528104755_create_affirmations.rb
class CreateAffirmations < ActiveRecord::Migration[6.1]
  def change
    create_table :affirmations do |t|
      t.string :text
      t.belongs_to :team_member

      t.timestamps
    end
  end
end
