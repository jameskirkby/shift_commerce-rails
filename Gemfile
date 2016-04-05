source 'https://rubygems.org'

# Console
gem 'pry-rails'

# Heroku
gem 'rails_12factor', group: :production

# Assets
gem 'sass-rails'
gem 'bootstrap-sass', "3.3.5.1"
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'imgix-rails'

# JSON
gem 'jbuilder', '~> 2.0'

# Docs
gem 'sdoc', '~> 0.4.0',          group: :doc

# User management
# devise is not used fully yet, but will be.  For now, we are just using its exception handling
gem "devise"

# Web server
gem 'puma'

# View and controller helpers
gem "decent_exposure", "~> 2.3"
gem "simple_form", "~> 3.1"

# Devops
gem "foreman", "~> 0.78"
gem "dotenv-rails", "~> 2.0"

# Shift
gem "flex_commerce_api", git: "https://github.com/flex-commerce/flex-ruby-gem.git", tag: 'v0.3.22'
gem "shift_commerce-ui_payment_gateway", git: "https://github.com/flex-commerce/shift_commerce-ui_payment_gateway.git", tag: "v0.0.9"
gem "shift_commerce-secure_trading", git: "https://github.com/flex-commerce/shift_commerce-secure_trading.git", tag: "v0.0.8"

group :development do
  gem "better_errors"
  gem "binding_of_caller"
end

group :development, :test do
  gem "capybara", "~> 2.6"
  gem "capybara_objects"
  gem "capybara-screenshot", "~> 1.0"
  gem "selenium-webdriver", "~> 2"
  gem "chromedriver-helper", ">= 0.0.8"
  gem "factory_girl_rails", "~> 4.5"
  gem "faker", "~> 1.5"
  gem "rack_session_access"
  gem "guard-rspec"
  gem "webmock", require: false
  gem "poltergeist"
end

group :test do
  gem "email_spec"
  gem "action_mailer_cache_delivery"
  gem "countries", "~> 1.2"
end

gemspec
