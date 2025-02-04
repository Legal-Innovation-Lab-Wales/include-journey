# frozen_string_literal: true

# db/migrate/20210528104758_create_survey.rb
class CreateSurvey < ActiveRecord::Migration[6.1]
  def change
    create_table :surveys do |t|
      t.string :name, null: false
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.boolean :active, null: false, default: false
      t.belongs_to :team_member, null: false, foreign_key: true

      t.timestamps
    end
  end
end
