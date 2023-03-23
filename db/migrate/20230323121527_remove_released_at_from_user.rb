# db/migrate/20230323121527_remove_released_at_from-user.rb
class RemoveReleasedAtFromUser < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :released_at, :date
  end
end