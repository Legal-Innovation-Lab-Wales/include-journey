# app/models/accommodation_type.rb
class AccommodationType < ApplicationRecord
  has_one :user

  validates :name, presence: true

  def json
    {name: name}
  end

  def to_csv
    [name]
  end
end
