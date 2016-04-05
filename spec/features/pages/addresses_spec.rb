require 'rails_helper'

RSpec.feature "Addresses Page Specs", type: :feature, js: true do
  include_context "global pages context"
  let(:starting_page) { page_object_for("addresses") }
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
    let!(:mock) { mock_server.add_addresses_for(customer_account, quantity: 10) }
    it "should have a view" do
      expect(view).to be_present
    end

    context "listing the addresses" do
      it "should list the full set" do
        mock_server.get_address_mocks_for(customer_account).each_with_index do |mock, idx|
          expect(view.address_at_index(idx).root_node).to have_text mock.first_name
          expect(view.address_at_index(idx).root_node).to have_text mock.middle_names
          expect(view.address_at_index(idx).root_node).to have_text mock.last_name
          expect(view.address_at_index(idx).root_node).to have_text mock.address_line_1
          expect(view.address_at_index(idx).root_node).to have_text mock.postcode
        end
      end
    end

    context "editing an address" do
      let(:edit_page) { page_object_for("edit_address", address: address_to_edit) }
      let(:address_to_edit) { mock_server.get_address_mocks_for(customer_account)[1] }
      it "should navigate to editing the address on clicking the edit link" do
        view.address_at_index(1).edit!
        expect(edit_page.attach).to be_present
      end
    end

    context "deleting an address" do
      let(:address_delete_confirmation_page) { page_object_for("delete_address_confirmation", address: address_to_delete) }
      let(:address_to_delete) { mock_server.get_address_mocks_for(customer_account)[1] }
      it "should navigate to deleting the address on clicking the delete link" do
        view.address_at_index(1).delete!
        expect(page).to have_content(I18n.t("addresses.destroy.destroyed"))
      end
    end

    context "setting the preferred shipping address" do
      it "should set the preferred shipping address on a row" do
        view.address_at_index(1).set_as_preferred_shipping!
        expect(page).to have_content(I18n.t("addresses.update.updated"))
        expect(view.address_at_index(1).is_preferred_shipping?).to be_truthy
      end
    end
    context "setting the preferred billing address" do
      it "should set the preferred billing address on a row" do
        view.address_at_index(1).set_as_preferred_billing!
        expect(page).to have_content(I18n.t("addresses.update.updated"))
        expect(view.address_at_index(1).is_preferred_billing?).to be_truthy
      end
    end
  end
end
