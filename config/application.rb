require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Fshop
  class Application < Rails::Application
    config.action_view.sanitized_allowed_tags = ['table', 'tr', 'td', 'p', 'div']
    config.assets.paths << Rails.root.join("app", "assets", "fonts", "twitter", "bootstrap")
    config.app_generators.stylesheet_engine :less
    config.less.paths << File.join(Rails.root, 'app', 'assets', 'stylesheets', 'custom_bootstrap')
    config.less.compress = false
    config.active_record.schema_format = :sql

    config.generators do |g|
      g.test_framework :rspec, views: false, fixture: true
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.template_engine :haml
      g.stylesheets false
      # don't generate RSpec tests for views and helpers
      g.view_specs false
      g.helper_specs false
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Kyiv'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :ru
    config.active_record.raise_in_transactional_callbacks = true
  end
end
