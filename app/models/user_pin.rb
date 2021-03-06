# app/models/user_pin.rb
class UserPin < ApplicationRecord
  before_destroy :update_order
  belongs_to :team_member
  belongs_to :user

  validates_presence_of :team_member_id, :user_id, :order

  def decrement
    previous_pin = UserPin.where('team_member_id = ? and user_pins.order = ?', team_member_id, order - 1)

    return unless previous_pin.present?

    previous_pin.update(order: order)
    update!(order: order - 1)
  end

  def increment
    next_pin = UserPin.where('team_member_id = ? and user_pins.order = ?', team_member_id, order + 1)

    return unless next_pin.present?

    next_pin.update(order: order)
    update!(order: order + 1)
  end

  private

  def update_order
    UserPin.all.where('team_member_id = ? and user_pins.order > ?', team_member_id, order).each do |pin|
      pin.update!(order: pin.order - 1)
    end
  end
end
