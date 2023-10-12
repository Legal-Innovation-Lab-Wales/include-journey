# app/models/local_authority_for_wallich.rb
class WallichLocalAuthority < ApplicationRecord
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
