require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Sof
  class Application < Rails::Application
    config.generators do |g|
      g.test_framework :rspec,
                        request_specs: false,
                        controller_specs: true,
                        view_specs: false,
                        routing_specs: false,
                        helper_specs: false
    end

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    config.active_job.queue_adapter = :sidekiq

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.active_storage.replace_on_assign_to_many = false
    config.cache_store = :redis_cache_store, { url: 'redis://localhost:6379/0/cache' }
  end
end
