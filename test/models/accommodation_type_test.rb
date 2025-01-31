require 'test_helper'

class AccommodationTypeTest < ActiveSupport::TestCase
  test 'accommodation type without name is invalid' do
    accommodation = AccommodationType.new
    assert_invalid accommodation, :name
  end

  test 'accommodation type with empty name is invalid' do
    accommodation = AccommodationType.new(name: '')
    assert_invalid accommodation, :name
  end

  test 'should allow accommodation type with valid name' do
    accommodation = AccommodationType.new(name: 'Hotel')
    assert_valid accommodation
    assert_equal 'Hotel', accommodation.name
  end

  test 'should not allow duplicate accommodation type names' do
    skip 'TODO: currently, uniqueness is not enforced'

    AccommodationType.create! name: 'Hotel'
    accommodation = AccommodationType.new(name: 'Hotel')
    assert_invalid accommodation, :name
  end
end
