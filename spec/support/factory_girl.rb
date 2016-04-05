require "factory_girl"
require "faker"

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.before(:each) { FactoryGirl.reload }
end
