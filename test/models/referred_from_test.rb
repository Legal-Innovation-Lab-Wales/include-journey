require 'test_helper'

class ReferredFromTest < ActiveSupport::TestCase
  test 'referred-from without name is invalid' do
    from = ReferredFrom.new
    assert_invalid from, :name
  end

  test 'referred-from with empty name is invalid' do
    from = ReferredFrom.new(name: '')
    assert_invalid from, :name
  end

  test 'should allow referred-from with valid name' do
    from = ReferredFrom.new(name: "Friend's sofa")
    assert_valid from
    assert_equal "Friend's sofa", from.name
  end

  test 'should not allow duplicate referred-from names' do
    skip 'TODO: currently, uniqueness is not enforced'

    ReferredFrom.create!(name: "Friend's sofa")
    from = ReferredFrom.new(name: "Friend's sofa")
    assert_invalid from, :name
  end
end
