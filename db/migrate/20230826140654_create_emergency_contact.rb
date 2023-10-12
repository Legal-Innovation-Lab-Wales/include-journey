class CreateEmergencyContact < ActiveRecord::Migration[6.1]
  def change
    create_table :emergency_contacts do |t|
      t.string :name
      t.string :relationship
      t.bigint :number
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
