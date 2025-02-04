# frozen_string_literal: true

# db/migrate/20210528104756_add_user_fields.rb
class AddUserFields < ActiveRecord::Migration[6.1]
  # rubocop:disable Metrics/MethodLength
  def change
    rename_column :users, :release_date, :released_at
    rename_column :users, :deletion_date, :deleted_at
    change_column :users, :released_at, :date

    change_table :users do |t|
      t.string :nomis_id
      t.string :pnc_no
      t.string :delius_no
      t.date :enrolled_at
      t.date :intervened_at
      t.string :release_establishment
      t.string :probation_area
      t.string :local_authority
      t.date :pilot_completed_at
      t.date :pilot_withdrawn_at
      t.string :withdrawn_reason
      t.string :index_offence
    end
  end
  # rubocop:enable Metrics/MethodLength
end
