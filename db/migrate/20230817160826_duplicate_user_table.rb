class DuplicateUserTable < ActiveRecord::Migration[6.1]
  def change
    # Duplicate the user table structure
    execute('CREATE TABLE wallich_journey_users AS SELECT * FROM users')

    # Remove columns from the duplicated table
    execute("ALTER TABLE wallich_journey_users DROP COLUMN nomis_id,
      DROP COLUMN pnc_no, DROP COLUMN delius_no,
      DROP COLUMN intervened_at, DROP COLUMN release_establishment,
      DROP COLUMN probation_area, DROP COLUMN pilot_completed_at,
      DROP COLUMN pilot_withdrawn_at, DROP COLUMN withdrawn_reason,
      DROP COLUMN index_offence, DROP COLUMN summary_panel")
  end
end
