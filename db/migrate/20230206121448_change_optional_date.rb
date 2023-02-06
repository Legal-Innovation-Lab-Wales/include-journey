class ChangeOptionalDate < ActiveRecord::Migration[6.1]
  def change
    rename_column :notes, :dated, :dated
  end
end
