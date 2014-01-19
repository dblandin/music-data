MusicData::Application.configure do
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.cache_classes                     = true
  config.eager_load                        = true
  config.serve_static_assets               = false

  config.logger = Logger.new('log/production.log', 2, 10.megabytes)
  config.logger.level = Logger.const_get(ENV['LOG_LEVEL'] ? ENV['LOG_LEVEL'].upcase : 'INFO')

  Sidekiq::Logging.logger = Logger.new('log/sidekiq.log', 2, 10.megabytes)
  Sidekiq::Logging.logger.level = Logger.const_get(ENV['LOG_LEVEL'] ? ENV['LOG_LEVEL'].upcase : 'INFO')


  config.assets.js_compressor = :uglifier
  config.assets.compile       = false
  config.assets.digest        = true
  config.assets.version = '1.0'

  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets.
  # application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
  # config.assets.precompile += %w( search.js )

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Disable automatic flushing of the log to improve performance.
  # config.autoflush_log = false
end
