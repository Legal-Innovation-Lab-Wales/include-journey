class CreateOtaEntries < ActiveRecord::Migration[6.1]
  def change
    return unless should_run_migration?

    create_table :ota_entries do |t|
      t.references :occupational_therapist_assessment, null: false, foreign_key: true
      t.references :occupational_therapist_metric, null: false, foreign_key: true
      t.references :occupational_therapist_score, null: false, foreign_key: true

      t.timestamps
    end
  end

  private

  def should_run_migration?
    ENV['ORGANISATION_NAME'] == 'wallich-journey'
  end
end
