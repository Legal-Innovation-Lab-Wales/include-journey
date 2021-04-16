class CreateContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :contacts do |t|
      t.string :name, null: false
      t.string :number
      t.string :email
      t.text :description, null: false
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
