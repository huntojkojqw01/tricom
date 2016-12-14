require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'csv'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Jpt
  class Application < Rails::Application
    # Use the responders controller from the responders gem
    config.app_generators.scaffold_controller :responders_controller


    config.generators do |g|


    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    # todo change timezone
    config.time_zone = 'Osaka'
    # config.time_zone = 'Hanoi'
    config.active_record.default_timezone = :local

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.i18n.default_locale = :ja

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.autoload_paths += %W(#{config.root}/lib)

    config.encoding = 'utf-8'

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    # config.active_record.whitelist_attributes = true

    # Enable the asset pipeline
    config.assets.enabled = true
    config.assets.paths << "#{Rails.root}/app/assets"
    config.assets.paths << "#{Rails.root}/public/assets"
    config.assets.paths << "#{Rails.root}/public/images"
    config.assets.paths << "#{Rails.root}/vendor/assets"
    # config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
    # config.assets.precompile << /(^[^_\/]|\/[^_])[^\/]*$/
    # config.assets.precompile += ["*.js", "*.css", "jquery-migrate-rails.js"]

    # Add the fonts path
    # config.assets.paths << Rails.root.join('app','assets','fonts')
    config.assets.paths += %W("#{Rails.root}/vendor/assets/fonts")
    # config.assets.paths << File.join(Rails.root, '/vendor/assets')
    # Add the fonts path
    # config.assets.paths << Rails.root.join('app', 'assets', 'fonts')

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
  end
end
