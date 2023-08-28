# app/models/accommodation_type.rb
class AccommodationType < ApplicationRecord
  has_one :user
end
