# app/models/local_authority_for_wallich.rb
class WallichLocalAuthority < ApplicationRecord
  has_one :user

  validates :name, presence: true

  def json
    {name: name}
  end

  def to_csv
    [name]
  end
end
