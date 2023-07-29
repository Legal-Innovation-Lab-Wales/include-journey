class AddVisibleToUserToUpload < ActiveRecord::Migration[6.1]
  def change
    add_column :uploads, :visible_to_user, :boolean, default: true
  end
end
