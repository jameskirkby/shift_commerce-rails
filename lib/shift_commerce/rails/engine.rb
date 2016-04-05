require "rubygems"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"
require "active_model"
require "flex_commerce_api"

module ShiftCommerce
  module Rails
    class Engine < ::Rails::Engine
      # isolate_namespace ShiftCommerce::Rails

      initializer "shift_commerce-rails.assets.precompile" do |app|
        app.config.assets.precompile += %w(application.css application.js)
      end

      initializer "shift_commerce-rails.set_helpers_path", before: "action_controller.set_helpers_path" do |app|
        app.config.helpers_paths.unshift File.expand_path("../../../app/helpers", __dir__)
      end

      initializer "better_errors.configure_rails_initialization" do |app|
        if use_error_handler? && using_better_errors?
          #insert_middleware(app)
          app.middleware.swap BetterErrors::Middleware, BetterErrors::Middleware, BetterErrorPage
        end
      end

      config.generators do |g|
        g.test_framework :rspec, :fixture => false
        g.fixture_replacement :factory_girl, :dir => 'spec/factories'
        g.assets false
        g.helper false
      end

      def insert_middleware(app)
        app.middleware.insert_before ActionDispatch::Cookies, ErrorMiddleware
      end

      def use_error_handler?
        !::Rails.env.production? and rails_app.config.consider_all_requests_local
      end

      def rails_app
        ::Rails.application
      end

      def using_better_errors?
        Object.const_defined?("BetterErrors")
      end
    end
  end
end





