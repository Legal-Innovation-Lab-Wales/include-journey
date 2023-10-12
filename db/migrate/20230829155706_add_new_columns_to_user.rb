class AddNewColumnsToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :address, :string
    add_column :users, :referral_date, :datetime
    add_column :users, :mam_date, :datetime
    add_column :users, :support_started_date, :datetime
    add_column :users, :brief_physical_description, :text
    add_column :users, :support_ended_date, :datetime
    add_column :users, :next_review_date, :datetime
  end
end
