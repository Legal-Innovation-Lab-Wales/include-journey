# app/models/local_authority.rb
class LocalAuthority < ApplicationRecord
  has_one :user
end
