class AddSuspendedToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :suspended, :boolean, :default => false
    add_column :users, :suspended_at, :datetime
  end
end
