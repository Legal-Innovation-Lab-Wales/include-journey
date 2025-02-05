class ChangeEmergencyContactNumberToText < ActiveRecord::Migration[6.1]
  def up
    change_column :emergency_contacts, :number, :string
  end

  def down
    change_column :emergency_contacts, :number, :bigint
  end
end
