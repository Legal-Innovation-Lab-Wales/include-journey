class Note < ApplicationRecord
  belongs_to :team_member
  belongs_to :user
end
