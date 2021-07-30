class Affirmation < ApplicationRecord
  belongs_to :team_member

  validates_presence_of :text, :team_member_id
end
