# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Helper methods to be used by all tests
    include ActiveSupport::Testing::TimeHelpers
    include AssertValid::Assertions

    def assert_destroyed(model)
      assert_raises ActiveRecord::RecordNotFound do
        model.reload
      end
    end
  end
end
