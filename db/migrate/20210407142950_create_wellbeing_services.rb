# frozen_string_literal: true

# db/migrate/20210407142950_create_wellbeing_services.rb
class CreateWellbeingServices < ActiveRecord::Migration[6.1]
  def change
    create_table :wellbeing_services do |t|
      t.belongs_to :team_member, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.string :website, null: false
      t.bigint :contact_number

      t.timestamps
    end
  end
end
