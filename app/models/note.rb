class Note < ApplicationRecord
  belongs_to :staff
  belongs_to :user
end
