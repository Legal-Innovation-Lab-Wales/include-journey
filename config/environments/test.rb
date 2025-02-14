# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

# The test environment is used exclusively to run your application's
# test suite. You never need to work with it otherwise. Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs. Don't rely on the data there!

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  config.cache_classes = false
  config.action_view.cache_template_loading = true

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{1.hour.to_i}",
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Store uploaded files on the local file system in a temporary directory.
  config.active_storage.service = :test

  config.action_mailer.perform_caching = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test
  config.action_mailer.default_url_options = {host: 'localhost', port: 3000}

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  config.regex_text_field = %r{\A[a-zA-Z0-9_!?,"'’+\-.()\r\n/&@–:— ]*\z}
  config.regex_name = %r{\A[a-zA-Z0-9'\-._()/, ]*\z}
  config.regex_file_name = /\A[a-zA-Z0-9\s_()-]+(\.(jpg|jpeg|png|pdf))?\z/i
  config.regex_telephone = /\A[0-9+ ]*\z/
  config.regex_website = %r{\A[a-zA-Z0-9'\-._()/#: ]*\z}
  config.regex_email = URI::MailTo::EMAIL_REGEXP
  config.regex_datetime = /\A[a-zA-Z0-9+\-.:() ]*\z/
  config.regex_postcode = /\A[a-zA-Z0-9 ]*\z/

  config.text_field_error = 'Please only use standard characters and punctuation'
  config.name_error = 'Please only use alphanumeric characters'
  config.file_name_error = 'Please only use alphanumeric characters, spaces, underscores, and hyphens.
                            Supported formats are JPEG, PNG, and PDF.'
  config.telephone_error = 'Please enter a valid telephone number'
  config.website_error = 'Please enter a valid website address'
  config.email_error = 'Please enter a valid email address'
  config.datetime_error = 'Please select a valid date'
  config.postcode_error = 'Please enter a valid postcode'
end
