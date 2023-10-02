class CreateHousingProvider < ActiveRecord::Migration[6.1]
  def change
    create_table :housing_providers do |t|
      t.string :name

      t.timestamps
    end
  end
end
