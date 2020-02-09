require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require File.expand_path("../initializers/log4r.rb", __FILE__)
include Log4r

module SolamimiWeb
  class Application < Rails::Application
        config.active_record.default_timezone = :local
        config.time_zone = 'Tokyo'

        # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
        # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
        config.i18n.default_locale = :ja
        I18n.enforce_available_locales = false

        config.colorize_logging = false
        require File.dirname(__FILE__) + "/../config/initializers/custom_logger"
        config.logger = CustomLogger::SystemLogger.instance.logger
        Log4r::Logger.send :include, ActiveRecord::SessionStore::Extension::LoggerSilencer

        config.enable_dependency_loading = true
        config.autoload_paths += %W(#{config.root}/lib)
    #    config.paths.add 'lib/.', eager_load: true

        config.generators do |g|
          g.assets false
          g.test_framework false
          g.helper false
          g.system_tests = nil
          g.template_engine :erb
        end

        # Settings in config/environments/* take precedence over those specified here.
        # Application configuration should go into files in config/initializers
        # -- all .rb files in that directory are automatically loaded.

        # Don't generate system test files.
        config.generators.system_tests = nil
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end
