class UserTag < ApplicationRecord
  belongs_to :tag
  belongs_to :user
  belongs_to :team_member

  validates_presence_of :tag_id, :user_id, :team_member_id
end
