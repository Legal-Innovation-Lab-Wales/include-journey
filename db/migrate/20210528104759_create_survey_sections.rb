# frozen_string_literal: true

# db/migrate/20210528104759_create_survey_sections.rb
class CreateSurveySections < ActiveRecord::Migration[6.1]
  def change
    create_table :survey_sections do |t|
      t.text :heading
      t.integer :order, null: false
      t.belongs_to :survey, null: false, foreign_key: true

      t.timestamps
    end
  end
end
