# frozen_string_literal: true

require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  fixtures :users, :contacts

  def setup
    super
    @user = users(:alice)
  end

  test 'contact without required fields is invalid' do
    contact = Contact.new
    assert_invalid contact, :user
    assert_invalid contact, :name
    assert_invalid contact, :description
  end

  test 'contact with malformed optional fields is invalid' do
    contact = Contact.new(
      user: @user,
      name: 'Smith',
      description: 'Agent',
      email: '!"$%^&*()',
      number: '!"$%^&*()',
    )
    assert_invalid contact, :email
    assert_invalid contact, :number
  end

  test 'should allow contact with valid fields' do
    contact = Contact.new(
      user: @user,
      name: 'Smith',
      description: 'Agent',
    )

    assert_valid contact
    assert_equal @user, contact.user
    assert_equal 'Smith', contact.name
    assert_equal 'Agent', contact.description
    assert_nil contact.email
    assert_nil contact.number
  end

  test 'should allow contact with valid optional fields' do
    contact = Contact.new(
      user: @user,
      name: 'Smith',
      description: 'Agent',
      email: 'agent.smith@example.com',
      number: '07555 999999',
    )

    assert_valid contact
    assert_equal @user, contact.user
    assert_equal 'Smith', contact.name
    assert_equal 'Agent', contact.description
    assert_equal 'agent.smith@example.com', contact.email
    assert_equal '07555 999999', contact.number
  end

  test 'contacts should load by associated user' do
    assert_equal contacts(:one, :two), @user.contacts.all
  end
end
