class AddApprovedToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :approved, :boolean, :default => false
    add_column :users, :approved_at, :datetime
  end
end
