# frozen_string_literal: true

class CreateContactLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :contact_logs do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :team_member, null: false, foreign_key: true
      t.belongs_to :contact_type, null: false, foreign_key: true
      t.belongs_to :contact_purpose, null: false, foreign_key: true
      t.datetime :start
      t.datetime :end
      t.string :notes
      t.boolean :attended, default: false

      t.timestamps
    end
  end
end
