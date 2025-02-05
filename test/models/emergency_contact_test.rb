# frozen_string_literal: true

require 'test_helper'

class EmergencyContactTest < ActiveSupport::TestCase
  fixtures :users, :emergency_contacts

  def setup
    super
    @user = users(:bob)
  end

  test 'emergency contact without required fields is invalid' do
    contact = EmergencyContact.new
    assert_invalid contact, :user
    assert_invalid contact, :name
    assert_invalid contact, :relationship
    assert_invalid contact, :number
  end

  test 'emergency contact with empty required fields is invalid' do
    contact = EmergencyContact.new(
      user: @user,
      name: '',
      relationship: '',
      number: '',
    )
    assert_invalid contact, :name
    assert_invalid contact, :relationship
    assert_invalid contact, :number
  end

  test 'emergency contact with malformed phone number is invalid' do
    contact = EmergencyContact.new(
      user: @user,
      name: 'Smith',
      relationship: 'Legal Guardian',
      number: '!"$%^&*()',
    )
    assert_invalid contact, :number
  end

  test 'should allow emergency contact with valid fields' do
    contact = EmergencyContact.new(
      user: @user,
      name: 'Smith',
      relationship: 'Legal Guardian',
      number: '07555 999999',
    )

    assert_valid contact
    assert_equal @user, contact.user
    assert_equal 'Smith', contact.name
    assert_equal 'Legal Guardian', contact.relationship
    assert_equal '07555 999999', contact.number
  end

  test 'emergency contact should load by associated user' do
    assert_equal emergency_contacts(:for_alice), users(:alice).emergency_contact
  end
end
