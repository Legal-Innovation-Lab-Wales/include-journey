# frozen_string_literal: true

# db/migrate/20210505111439_create_user_tags.rb
class CreateUserTags < ActiveRecord::Migration[6.1]
  def change
    create_table :user_tags do |t|
      t.belongs_to :tag
      t.belongs_to :user
      t.belongs_to :team_member

      t.timestamps
    end

    # ensure that a user can't be assigned the same tag multiple times
    add_index :user_tags, %i[tag_id user_id], unique: true
  end
end
