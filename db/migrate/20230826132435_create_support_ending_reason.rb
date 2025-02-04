# frozen_string_literal: true

class CreateSupportEndingReason < ActiveRecord::Migration[6.1]
  def change
    create_table :support_ending_reasons do |t|
      t.string :name

      t.timestamps
    end
  end
end
