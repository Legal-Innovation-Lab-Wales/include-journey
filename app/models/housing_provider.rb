# frozen_string_literal: true

# app/models/housing_provider.rb
class HousingProvider < ApplicationRecord
  has_one :user

  validates :name, presence: true

  def json
    {name: name}
  end

  def to_csv
    [name]
  end
end
