class CreateSupportEndedReason < ActiveRecord::Migration[6.1]
  def change
    create_table :support_ended_reasons do |t|
      t.string :name

      t.timestamps
    end
  end
end
