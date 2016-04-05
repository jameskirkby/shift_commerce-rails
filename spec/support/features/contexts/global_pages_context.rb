RSpec.shared_context "global pages context" do
  let(:default_currency) { "£" }
  let(:flex_root_url) { Rails.application.secrets.flex_root_url }
  let(:flex_api_key) { Rails.application.secrets.flex_api_key }
  let(:flex_account) { Rails.application.secrets.flex_account }
  let(:api_root) do
    URI.parse("#{flex_root_url}/#{flex_account}/v1").tap do |u|
      u.user = flex_account
      u.password = flex_api_key
    end
  end
  let(:api_default_request_headers) { { "Accept" => "application/vnd.api+json", "Content-Type" => "application/vnd.api+json" } }
  let(:api_default_response_headers) { { "Content-Type" => "application/vnd.api+json" } }
  let(:mock_server) { mock_server_instance }  # @TODO Gradually deprecate this
  let(:paypal_email) { ENV["TEST_PAYPAL_EMAIL_BUYER"] }
  let(:paypal_password) { ENV["TEST_PAYPAL_PASSWORD_BUYER"] }
end