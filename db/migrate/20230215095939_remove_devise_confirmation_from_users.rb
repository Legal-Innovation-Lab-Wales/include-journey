class RemoveDeviseConfirmationFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :confirmation_token, :string
    remove_column :users, :confirmed_at, :dattime
    remove_column :users, :confirmation_sent_at, :datetime
    remove_column :users, :unconfirmed_email, :string
  end
end
