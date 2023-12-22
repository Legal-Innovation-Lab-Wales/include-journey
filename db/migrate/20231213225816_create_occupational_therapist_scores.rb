class CreateOccupationalTherapistScores < ActiveRecord::Migration[6.1]
  def change
    return unless should_run_migration?

    create_table :occupational_therapist_scores do |t|
      t.string :value

      t.timestamps
    end
  end

  private

  def should_run_migration?
    ENV['ORGANISATION_NAME'] == 'wallich-journey'
  end
end
