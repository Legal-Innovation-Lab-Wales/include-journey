# frozen_string_literal: true

# db/migrate/20210528104766_create_achievements.rb
class CreateAchievements < ActiveRecord::Migration[6.1]
  # rubocop:disable Metrics/MethodLength
  def change
    create_table :achievements do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.string :entities, null: false
      t.date :starts_at
      t.date :ends_at
      t.integer :bronze_count, null: false, default: 0
      t.integer :silver_count, null: false, default: 0
      t.integer :gold_count, null: false, default: 0

      t.timestamps
    end
  end
  # rubocop:enable Metrics/MethodLength
end
