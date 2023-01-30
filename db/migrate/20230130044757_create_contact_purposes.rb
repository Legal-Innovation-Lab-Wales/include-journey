class CreateContactPurposes < ActiveRecord::Migration[6.1]
  def change
    create_table :contact_purposes do |t|
      t.text :name, null: false

      t.timestamps
    end
  end
end
