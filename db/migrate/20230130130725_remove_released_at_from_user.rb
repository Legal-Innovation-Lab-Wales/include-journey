class RemoveReleasedAtFromUser < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :released_at, :date
  end
end
