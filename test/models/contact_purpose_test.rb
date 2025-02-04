# frozen_string_literal: true

require 'test_helper'

class ContactPurposeTest < ActiveSupport::TestCase
  test 'contact purpose without name is invalid' do
    purpose = ContactPurpose.new
    assert_invalid purpose, :name
  end

  test 'contact purpose with empty name is invalid' do
    purpose = ContactPurpose.new(name: '')
    assert_invalid purpose, :name
  end

  test 'should allow contact purpose with valid name' do
    purpose = ContactPurpose.new(name: 'No good reason')
    assert_valid purpose
    assert_equal 'No good reason', purpose.name
  end

  test 'should not allow duplicate contact purpose names' do
    skip 'TODO: currently, uniqueness is not enforced'

    ContactPurpose.create!(name: 'No good reason')
    purpose = ContactPurpose.new(name: 'No good reason')
    assert_invalid purpose, :name
  end
end
