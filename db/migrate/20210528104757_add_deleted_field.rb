# db/migrate/20210528104757_add_deleted_field.rb
class AddDeletedField < ActiveRecord::Migration[6.1]
  def change
    change_table :users do |t|
      t.boolean :deleted, null: false, default: false
    end
  end
end
