# frozen_string_literal: true

class CreateWellbeingScoreValues < ActiveRecord::Migration[6.1]
  def change
    create_table :wellbeing_score_values do |t|
      t.string :name
      t.string :color

      t.timestamps
    end
  end
end
