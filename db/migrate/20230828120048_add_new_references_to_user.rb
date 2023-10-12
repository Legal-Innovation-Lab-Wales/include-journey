class AddNewReferencesToUser < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :accommodation_type, foreign_key: true, null: true
    add_reference :users, :housing_provider, foreign_key: true, null: true
    add_reference :users, :support_ending_reason, foreign_key: true, null: true
    add_reference :users, :referred_from, foreign_key: true, null: true
    add_reference :users, :priority, foreign_key: true, null: true
    add_reference :users, :wallich_local_authority, foreign_key: true, null: true
  end
end
