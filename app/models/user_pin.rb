# app/models/user_pin.rb
class UserPin < ApplicationRecord
  before_destroy :update_order
  belongs_to :team_member
  belongs_to :user

  validates_presence_of :team_member_id, :user_id, :order

  private

  def update_order
    UserPin.all.where('team_member_id = ? and user_pins.order > ?', team_member_id, order).each do |pin|
      pin.update!(order: pin.order - 1)
    end
  end
end
