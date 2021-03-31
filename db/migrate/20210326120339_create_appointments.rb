class CreateAppointments < ActiveRecord::Migration[6.1]
  def change
    create_table :appointments do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.datetime :when_datetime
      t.string :who_with
      t.string :where
      t.string :what
      t.boolean :attended, default: false
      t.integer :duration

      t.timestamps
    end
  end
end
