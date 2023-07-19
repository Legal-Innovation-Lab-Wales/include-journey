class Upload < ApplicationRecord
  belongs_to :uploadable, polymorphic: true
  has_many :photos
end
