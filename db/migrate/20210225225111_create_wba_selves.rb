class CreateWbaSelves < ActiveRecord::Migration[6.1]
  def change
    create_table :wba_selves do |t|
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
