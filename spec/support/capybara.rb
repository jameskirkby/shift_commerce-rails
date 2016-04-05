require "capybara/rspec"
require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {js_errors: false})
end

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

Capybara::Screenshot.register_driver(:chrome) do |driver, path|
  driver.browser.save_screenshot(path)
end

Capybara.configure do |config|
  driver = ENV.key?("TEST_BROWSER") ? ENV["TEST_BROWSER"].to_sym : :poltergeist
  config.javascript_driver = driver
  config.always_include_port = true
  config.server_port = 23456
  config.default_max_wait_time = 5
end