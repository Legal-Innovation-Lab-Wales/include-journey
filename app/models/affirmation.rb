# app/models/affirmation.rb
class Affirmation < ApplicationRecord
  belongs_to :team_member

  validates_presence_of :text, :team_member_id

  def date
    scheduled_date.strftime('%d/%m/%Y')
  end
end
