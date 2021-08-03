# db/migrate/20210528104756_add_user_fields.rb
class AddUserFields < ActiveRecord::Migration[6.1]
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def change
    rename_column :users, :release_date, :release
    rename_column :users, :deletion_date, :deletion
    change_column :users, :release, :date

    change_table :users do |t|
      t.string :nomis_id
      t.string :pnc_no
      t.string :delius_no
      t.date :enrolment
      t.date :intervention
      t.string :release_establishment
      t.string :probation_area
      t.string :local_authority
      t.date :pilot_completed
      t.date :pilot_withdrawn
      t.string :withdrawn_reason
      t.string :index_offence
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
