require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MyJourney
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1
    config.exceptions_app = self.routes

    config.time_zone = 'London'

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Generator Configuration
    config.generators do |g|
      g.stylesheets     false  # Skip generating stylesheets
      g.javascripts     false  # Skip generating JavaScript files
      g.helper          false  # Skip generating helper files
      g.test_framework  false  # Skip generating test files
      g.assets          false  # Skip generating asset files (stylesheets and JavaScript)
      g.jbuilder        false  # Skip generating Jbuilder views
    end

    # Version of assets, change this if you want to expire all assets
    config.assets.version = '1.0'

    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      if File.exist?(env_file)
        YAML.safe_load(File.open(env_file)).each do |key, value|
          ENV[key.to_s] = value
        end
      end
    end

    config.to_prepare do
      Devise::Mailer.layout 'mailer'
    end
  end
end
