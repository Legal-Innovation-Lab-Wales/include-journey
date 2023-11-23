class AddUserToFolder < ActiveRecord::Migration[6.1]
  def change
    add_reference :folders, :user, null: true, foreign_key: true
  end
end
