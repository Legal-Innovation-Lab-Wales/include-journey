class CreateUploadFiles < ActiveRecord::Migration[6.1]
  def change
    create_table :upload_files do |t|
      t.binary :data
      t.references :upload, null: false, foreign_key: true

      t.timestamps
    end
  end
end
