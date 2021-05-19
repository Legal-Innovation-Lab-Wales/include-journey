# db/migrate/20210505111439_create_user_tags.rb
class CreateUserTags < ActiveRecord::Migration[6.1]
  def change
    create_table :user_tags do |t|
      t.belongs_to :tag
      t.belongs_to :user
      t.belongs_to :team_member

      t.timestamps
    end
  end
end
