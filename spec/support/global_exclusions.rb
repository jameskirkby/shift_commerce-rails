RSpec.configure do |c|
  c.filter_run_excluding :payment unless ENV.key?("PAYPAL_LOGIN") && ENV.key?("PAYPAL_PASSWORD") && ENV.key?("PAYPAL_SIGNATURE")
  c.filter_run_excluding :requires_email unless ENV.key?("FLEX_MAIL_CACHE")
end