class CreateWbaSelfPermissions < ActiveRecord::Migration[6.1]
  def change
    create_table :wba_self_permissions do |t|
      t.belongs_to :wba_self, null: false, foreign_key: true
      t.belongs_to :team_member, null: false, foreign_key: true

      t.timestamps
    end
  end
end
