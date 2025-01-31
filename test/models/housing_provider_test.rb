require 'test_helper'

class HousingProviderTest < ActiveSupport::TestCase
  test 'housing provider without name is invalid' do
    provider = HousingProvider.new
    assert_invalid provider, :name
  end

  test 'housing provider with empty name is invalid' do
    provider = HousingProvider.new(name: '')
    assert_invalid provider, :name
  end

  test 'should allow housing provider with valid name' do
    provider = HousingProvider.new(name: "Friend's sofa")
    assert_valid provider
    assert_equal "Friend's sofa", provider.name
  end

  test 'should not allow duplicate housing provider names' do
    skip 'TODO: currently, uniqueness is not enforced'

    HousingProvider.create!(name: "Friend's sofa")
    provider = HousingProvider.new(name: "Friend's sofa")
    assert_invalid provider, :name
  end
end
