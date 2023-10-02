# app/models/priority.rb
class Priority < ApplicationRecord
  has_one :user

  validates_presence_of :name

  def json
    {
      'name': name
    }
  end

  def to_csv
    [name]
  end
end
