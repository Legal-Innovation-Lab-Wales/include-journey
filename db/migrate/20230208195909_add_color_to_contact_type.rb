# frozen_string_literal: true

class AddColorToContactType < ActiveRecord::Migration[6.1]
  def change
    add_column :contact_types, :color, :string
  end
end
