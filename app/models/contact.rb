class Contact < ApplicationRecord
  belongs_to :user

  validates_presence_of :user_id, :name, :description
end
