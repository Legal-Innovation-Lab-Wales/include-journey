# app/models/housing_provider.rb
class HousingProvider < ApplicationRecord
  has_one :user
end
