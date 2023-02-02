class AddOptionalDateToNotes < ActiveRecord::Migration[6.1]
  def change
    add_column :notes, :optional_date, :datetime
  end
end
