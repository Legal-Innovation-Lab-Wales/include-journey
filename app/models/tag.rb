class Tag < ApplicationRecord
  belongs_to :team_member
  has_many :user_tags, foreign_key: :tag_id

  validates_presence_of :tag, :team_member_id
end
