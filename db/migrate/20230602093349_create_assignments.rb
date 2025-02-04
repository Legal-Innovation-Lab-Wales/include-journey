# frozen_string_literal: true

class CreateAssignments < ActiveRecord::Migration[6.1]
  def change
    create_table :assignments do |t|
      t.references :team_member, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
