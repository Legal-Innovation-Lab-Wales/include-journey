class CreatePriority < ActiveRecord::Migration[6.1]
  def change
    create_table :priorities do |t|
      t.string :name

      t.timestamps
    end
  end
end
