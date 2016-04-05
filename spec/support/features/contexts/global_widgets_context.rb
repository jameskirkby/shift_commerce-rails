RSpec.shared_context "global widgets context" do
  let(:default_currency) { "£" }
  let(:flex_root_url) { Rails.application.secrets.flex_root_url }
  let(:flex_api_key) { Rails.application.secrets.flex_api_key }
  let(:flex_account) { Rails.application.secrets.flex_account }
  let(:api_root) { "#{flex_root_url}/#{flex_account}/v1" }
  let(:mock_server) { mock_server_instance }  # @TODO Gradually deprecate this

end