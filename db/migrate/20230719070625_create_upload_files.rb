class CreateUploadFiles < ActiveRecord::Migration[6.1]
  def change
    create_table :upload_files do |t|
      t.string :name
      t.binary :data
      t.string :content_type
      t.references :upload, null: false, foreign_key: true

      t.timestamps
    end
  end
end
