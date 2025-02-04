# frozen_string_literal: true

# db/migrate/20210225225120_create_user_pins.rb
class CreateUserPins < ActiveRecord::Migration[6.1]
  def change
    create_table :user_pins do |t|
      t.belongs_to :team_member, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.integer :order

      t.timestamps
    end
  end
end
