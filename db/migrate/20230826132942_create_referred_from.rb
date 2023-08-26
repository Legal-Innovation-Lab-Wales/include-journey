class CreateReferredFrom < ActiveRecord::Migration[6.1]
  def change
    create_table :referred_froms do |t|
      t.string :name

      t.timestamps
    end
  end
end
