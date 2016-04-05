require_relative "./flex_commerce_api"

ShiftCommerce::UiPaymentGateway.config do |config|
  config.paypal_login = Rails.application.secrets.paypal_login
  config.paypal_password = Rails.application.secrets.paypal_password
  config.paypal_signature = Rails.application.secrets.paypal_signature
  config.current_cart_method = :open_cart
  config.order_model = "FlexCommerce::Order"
  config.address_model = "FlexCommerce::Address"
  config.shipping_method_model = "FlexCommerce::ShippingMethod"
  config.test_mode = true if ENV["PAYMENT_GATEWAY_TEST_MODE"]
  config.wiredump_device = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT)).tap {|logger| logger.push_tags("active_merchant") } if ENV["PAYMENT_GATEWAY_TEST_MODE"]
  config.api_root = FlexCommerceApi.config.api_base_url
end