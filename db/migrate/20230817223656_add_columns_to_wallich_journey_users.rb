class AddColumnsToWallichJourneyUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :wallich_journey_users, :preferred_name, :string
    add_column :wallich_journey_users, :address, :string
    add_column :wallich_journey_users, :occupational_therapist_scores, :string, array: true, default: []
    add_column :wallich_journey_users, :occupational_therapist_scores_created_at, :datetime
    add_column :wallich_journey_users, :old_occupational_therapist_scores, :text, array: true, default: []
    add_column :wallich_journey_users, :old_occupational_therapist_scores_creation_dates, :string, array: true, default: []
    add_column :wallich_journey_users, :referral, :datetime
    add_column :wallich_journey_users, :mam, :datetime
    add_column :wallich_journey_users, :support_started, :datetime
    add_column :wallich_journey_users, :brief_physical_description, :text
    add_column :wallich_journey_users, :support_ended, :datetime
    add_column :wallich_journey_users, :next_review, :datetime
  end
end
