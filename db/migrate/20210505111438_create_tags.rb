# db/migrate/20210505111438_create_tags.rb
class CreateTags < ActiveRecord::Migration[6.1]
  def change
    create_table :tags do |t|
      t.string :tag, unique: true
      t.belongs_to :team_member

      t.timestamps
    end
  end
end
