class AddTotalUploadSize < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :total_upload_size, :integer, default: 0
    add_column :team_members, :total_upload_size, :integer, default: 0
  end
end
