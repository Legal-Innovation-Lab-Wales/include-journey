class CreateFolder < ActiveRecord::Migration[6.1]
  def change
    create_table :folders do |t|
      t.string :name
      t.references :parent_folder, foreign_key: { to_table: :folders }
      t.references :team_member, null: false, foreign_key: true

      t.timestamps
    end
  end
end
