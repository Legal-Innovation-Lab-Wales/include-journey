# db/migrate/20210326120339_create_appointments.rb
class CreateAppointments < ActiveRecord::Migration[6.1]
  # rubocop:disable Metrics/MethodLength
  def change
    create_table :appointments do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :team_member, null: true, foreign_key: true
      t.datetime :start
      t.datetime :end
      t.string :who_with
      t.string :where
      t.string :what
      t.boolean :attended, default: false
      t.timestamps
    end
  end
  # rubocop:enable Metrics/MethodLength
end
