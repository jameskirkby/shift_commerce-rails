ENV['RAILS_ENV'] ||= 'test'

require File.expand_path("../dummy/config/environment.rb", __FILE__)

# Load support files
Dir[File.join File.dirname(__FILE__), 'support', '**', '*.rb'].each { |f| require f }
require 'rspec/rails'
require 'rspec/autorun'
require 'factory_girl_rails'

Rails.backtrace_cleaner.remove_silencers!

RSpec.configure do |config|
 config.include ShiftCommerce::Rails::Engine.routes.url_helpers
 config.mock_with :rspec
 config.use_transactional_fixtures = true
 config.color = :true
 config.tty = true
 config.infer_base_class_for_anonymous_controllers = false
 config.order = "random"
end

FactoryGirl.definition_file_paths << File.join(File.dirname(__FILE__), 'factories')
FactoryGirl.find_definitions