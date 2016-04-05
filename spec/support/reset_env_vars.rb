RSpec.configure do |config|
  config.before(:suite) do
    ENV["SITE_PASSWORD"] = nil
    ENV["PRIMARY_DOMAIN"] = nil
  end
end
