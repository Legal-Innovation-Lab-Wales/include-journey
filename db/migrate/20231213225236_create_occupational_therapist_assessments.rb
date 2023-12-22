class CreateOccupationalTherapistAssessments < ActiveRecord::Migration[6.1]
  def change
    return unless should_run_migration?

    create_table :occupational_therapist_assessments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :team_member, null: false, foreign_key: true

      t.timestamps
    end
  end

  private

  def should_run_migration?
    ENV['ORGANISATION_NAME'] == 'wallich-journey'
  end
end
