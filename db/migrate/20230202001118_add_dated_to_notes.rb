# frozen_string_literal: true

class AddDatedToNotes < ActiveRecord::Migration[6.1]
  def change
    add_column :notes, :dated, :datetime
  end
end
