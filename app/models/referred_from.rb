# app/models/referred_from.rb
class ReferredFrom < ApplicationRecord
  has_one :user
end
