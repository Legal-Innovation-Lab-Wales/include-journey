# db/migrate/timestamp_remove_occupational_therapist_related_columns_from_users.rb
class RemoveOccupationalTherapistRelatedColumnsFromUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :occupational_therapist_scores, :bigint, array: true, default: []
    remove_column :users, :occupational_therapist_scores_date, :datetime
    remove_column :users, :old_occupational_therapist_scores, :bigint, array: true, default: []
    remove_column :users, :old_occupational_therapist_scores_dates, :datetime, array: true, default: []
  end
end
