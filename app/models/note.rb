# app/models/note.rb
class Note < ApplicationRecord
  belongs_to :team_member
  belongs_to :user

  validates_presence_of :team_member_id, :user_id, :visible_to_user, :content
end
