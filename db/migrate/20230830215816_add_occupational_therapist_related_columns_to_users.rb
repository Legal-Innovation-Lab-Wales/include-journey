class AddOccupationalTherapistRelatedColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :occupational_therapist_scores, :bigint, array: true, default: []
    add_column :users, :occupational_therapist_scores_date, :datetime
    add_column :users, :old_occupational_therapist_scores, :bigint, array: true, default: []
    add_column :users, :old_occupational_therapist_scores_dates, :datetime, array: true, default: []
  end
end
