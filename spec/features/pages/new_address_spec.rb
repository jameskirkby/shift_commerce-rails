require 'rails_helper'

RSpec.feature "New Address Page Specs", type: :feature, js: true do
  include_context "global pages context"
  let(:starting_page) { page_object_for("new_address") }
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
    let!(:index_mock) { mock_server.add_addresses_for(customer_account) }# As we go to the index page afterwards


    it "should have a view" do
      expect(view).to be_present
    end

    context "create address book" do
      context "with good input" do
        let(:create_attributes) { attributes_for(:address) }
        it "should be be successful" do
          view.create_entry!(create_attributes)
          expect(page).to have_content(I18n.t("addresses.create.created"))
        end
      end
      # This test ensures that no matter what errors the API really sends us, they are displayed
      #  It is not done with the real API as we cannot guarantee a way of doing it.
      context "with bad input" do
        let(:errors) { { address_line_1: ["Invalid address line 1"], address_line_2: ["Invalid address line 2"], address_line_3: ["Invalid address line 3"], city: ["Invalid city"], state: ["Invalid state"], postcode: ["Invalid post code"], preferred_billing: ["Invalid preferred billing"], preferred_shipping: ["Invalid preferred shipping"]  } }
        let!(:mock) { mock_server.allow_address_create_for(customer_account, errors: errors) }
        it "should not be be successful and display all errors correctly" do
          view.create_entry!({})
          expect(page).not_to have_content(I18n.t("addresses.create.created"))
          view.assert_validation_errors(errors)
        end
      end
    end
  end
end
