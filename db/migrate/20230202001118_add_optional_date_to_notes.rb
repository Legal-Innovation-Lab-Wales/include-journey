#adds attribute optional_note to notes table
class AddOptionalDateToNotes < ActiveRecord::Migration[6.1]
  def change
    add_column :notes, :dated, :datetime
  end
end
