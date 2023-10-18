class AddCreatedByToUsers < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :created_by, foreign_key: { to_table: :team_members }, index: true
  end
end
