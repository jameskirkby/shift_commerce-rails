require 'rails_helper'

RSpec.feature "Edit Address Page Specs", type: :feature, js: true do
  include_context "global pages context"
  let(:starting_page) { page_object_for("edit_address", address: address) }
  subject { starting_page.visit }
  it_should_behave_like "any site page" # Verifies common requirements across all pages
  let(:view) { subject.view }
  context "main" do
    let!(:customer_account) do
      mock_server.add_basic_customer_account!.tap do |a|
        mock_server.login!(a)
      end
    end
    after(:each) { customer_account.destroy }
    let!(:add_addresses_mock) { mock_server.add_addresses_for(customer_account, quantity: 2) }
    let(:address) { mock_server.get_address_mocks_for(customer_account)[1] }
    it "should have a view" do
      expect(view).to be_present
    end

    context "update address" do
      context "with good input" do
        let(:update_attributes) { attributes_for(:address) }
        it "should be be successful" do
          view.update_entry!(update_attributes)
          expect(page).to have_content(I18n.t("addresses.update.updated"))
        end
      end
      context "with bad input" do
        let(:errors) { { address_line_1: ["Invalid address line 1"], address_line_2: ["Invalid address line 2"], address_line_3: ["Invalid address line 3"], city: ["Invalid city"], state: ["Invalid state"], postcode: ["Invalid post code"], preferred_billing: ["Invalid preferred billing"], preferred_shipping: ["Invalid preferred shipping"]  } }
        let!(:mock) { mock_server.allow_address_update_for(customer_account, errors: errors) }
        let(:update_attributes) { attributes_for(:address_resource)[:attributes] }
        it "should not be be successful and display all errors correctly" do
          view.update_entry!({})
          expect(page).not_to have_content(I18n.t("addresses.update.updated"))
          view.assert_validation_errors(errors)
        end
      end
    end
  end
end
