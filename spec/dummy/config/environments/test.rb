Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  config.log_level = :debug

  # Configure static asset server for tests with Cache-Control for performance.
  config.serve_static_files  = true
  config.static_cache_control = 'public, max-age=3600'

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  config.imgix = {
    source: ENV.fetch('IMGIX_SOURCE'),
    secure_url_token: ENV.fetch('IMGIX_SECURE_URL_TOKEN')
  }

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :cache
  config.action_mailer.cache_settings = { location: ENV["FLEX_MAIL_CACHE"] }
  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  config.middleware.use RackSessionAccess::Middleware # Used to provide access to the session in development and test envs

  if ENV["FLEX_SERVER_MODE"] == "emulator"
    rack_app = Rack::Builder.new do
      map "/#{Rails.application.secrets.flex_account}" do
        use ::Rack::Sendfile, Rails.application.config.action_dispatch.x_sendfile_header
        use ::Rack::MethodOverride
        use ::ActionDispatch::RequestId
        use ::Rails::Rack::Logger, Rails.application.config.log_tags
        use ::ActionDispatch::Callbacks
        use ::ActionDispatch::Cookies
        use ::ActionDispatch::ParamsParser
        use ::Rack::Head
        use ::Rack::ConditionalGet
        use ::Rack::ETag, "no-cache"

        run ShiftCommerceEmulator::Engine
      end
    end
    
    FlexCommerceApi.config do |config|
      config.adapter = [:rack, rack_app]
    end
  end
end
