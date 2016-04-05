RSpec.configure do |config|
  config.before(:suite) do
    unless ENV.key?("FLEX_MAIL_CACHE")
      puts "WARNING: Missing 'FLEX_MAIL_CACHE' environment variable. Tests that need the output from emails will not work"
    end
  end
end