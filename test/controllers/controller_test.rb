# frozen_string_literal: true

require 'test_helper'

class ControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  fixtures :users, :team_members

  def setup
    super
    @user = users :alice
    @admin, @team_member = team_members :alan, :barbara
  end
end
