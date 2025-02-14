# frozen_string_literal: true

# unless ENV.key? 'MFA_OTP_SECRET_KEY'
#   raise 'MFA_OTP_SECRET_KEY environment variable is not set.
#     This environment variable must exist at load time, as it is used by the Devise helper on the TeamMember class.'
# end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Add more helper methods to be used by all tests here...
    include AssertValid::Assertions
  end
end
