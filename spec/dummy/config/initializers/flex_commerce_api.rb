FlexCommerceApi.config do |config|
  config.flex_root_url||=Rails.application.secrets.flex_root_url
  config.flex_account=Rails.application.secrets.flex_account
  config.flex_api_key=Rails.application.secrets.flex_api_key
  config.logger = Rails.logger
end