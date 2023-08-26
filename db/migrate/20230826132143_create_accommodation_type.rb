class CreateAccommodationType < ActiveRecord::Migration[6.1]
  def change
    create_table :accommodation_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
