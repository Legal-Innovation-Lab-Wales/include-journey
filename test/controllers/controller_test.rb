# frozen_string_literal: true

require 'test_helper'

class ControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  fixtures :all

  def setup
    super
    @user = users :alice
    @admin, @team_member = team_members :alan, :barbara

    setup_2fa(@admin)
    setup_2fa(@team_member)
  end

  protected

  # Request helpers

  def valid_params
    raise 'valid_params not implemented'
  end

  def each_missing_param(&block)
    params = valid_params
    params.each_key do |key|
      block.call(params.except(key))
    rescue ActionController::ParameterMissing
      next
    end
  end

  # Model assertions

  def assert_destroyed(record)
    assert_raises ActiveRecord::RecordNotFound do
      record.reload
    end
  end

  def assert_not_destroyed(record)
    record.reload
  end

  # Response assertions

  def assert_label(for_id)
    assert_select "label[for=\"#{for_id}\"]"
  end

  def assert_input(id, value, with_label: true)
    assert_select "input##{id}[value=\"#{value}\"]"
    assert_label id if with_label
  end

  def assert_textarea(id, value, with_label: true)
    assert_select "textarea##{id}", value
    assert_label id if with_label
  end

  def assert_selected_option(id, value, text, with_label: true)
    assert_select "select##{id} option[value=\"#{value}\"][selected]", text
    assert_label id if with_label
  end

  private

  def setup_2fa(team_member)
    team_member.otp_secret = TeamMember.generate_otp_secret
    team_member.otp_required_for_login = true
    team_member.generate_otp_backup_codes!
    team_member.save!
  end
end
