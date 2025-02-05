# frozen_string_literal: true

# app/models/user_pin.rb
class UserPin < ApplicationRecord
  before_destroy :update_order
  belongs_to :team_member
  belongs_to :user

  validates :team_member_id, :user_id, :order, presence: true

  def decrement
    previous_pin = UserPin.where('team_member_id = ? and user_pins.order = ?', team_member_id, order - 1)

    return if previous_pin.blank?

    previous_pin.update(order: order)
    update!(order: order - 1)
  end

  def increment
    next_pin = UserPin.where('team_member_id = ? and user_pins.order = ?', team_member_id, order + 1)

    return if next_pin.blank?

    next_pin.update(order: order)
    update!(order: order + 1)
  end

  private

  def update_order
    UserPin.where(team_member_id: team_member_id, order: order..)
      .find_each do |pin|
        pin.update!(order: pin.order - 1)
      end
  end
end
