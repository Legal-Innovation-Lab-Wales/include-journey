class CreateContactTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :contact_types do |t|
      t.text :name, null: false

      t.timestamps
    end
  end
end
