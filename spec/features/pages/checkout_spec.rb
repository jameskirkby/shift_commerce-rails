require 'rails_helper'

RSpec.feature "Checkout Specs", type: :feature, js: true do
  # @TODO Remove this when the real server is ready
  include_context "global pages context"
  let(:starting_page) { page_object_for("checkout") }
  let(:new_transaction_page) { page_object_for("new_transaction").attach }
  let(:reloaded_cart) { FlexCommerce::Cart.find(cart.id) } # @TODO Rename this
  let(:shipping_method_id) { FlexCommerce::ShippingMethod.all.first.id }
  let(:addresses_class) { FlexCommerce::Address }
  subject { starting_page.visit }
  let(:view) { subject.view }
  it_should_behave_like "any site page" # Verifies common requirements across all pages
  describe "with items in the cart" do
    let!(:products) { FlexCommerce::Product.where(filter: {"in_stock" => {"eq" => true}}).paginate(per_page: 10, page: 1).all }
    let(:variants) { products[0..9].map { |p| FlexCommerce::Product.find("slug:#{p.slug}").variants.first } }
    context "while logged in" do
      let!(:cart) { mock_server.create_basket variants: variants, customer_account_id: customer_account.id }
      let!(:customer_account) do
        mock_server.add_basic_customer_account!.tap do |a|
          mock_server.login!(a)
        end
      end
      after(:each) { customer_account.destroy }
      let!(:addresses) { mock_server.add_addresses_for(customer_account, quantity: 3) }
      let!(:international_addresses) { mock_server.add_addresses_for(customer_account, quantity: 2, country: "AU") }
      let(:new_address) { build(:address) }
      let(:new_invalid_address) { build(:address, address_line_1: "") }
      let(:updated_address) { customer_account.addresses.detect { |a| a.id == addresses[2].id} }
      let(:address_to_select) { addresses[2] }

      #
      # Billing Address
      #
      context "billing address" do
        it "should pre populate the billing address when a predefined address is selected." do
          view.shipping_address.select_from_saved(address_to_select) # Must always have a shipping address - so quickest way to get one
          view.billing_address.select_from_saved(address_to_select)
          view.assert_billing_address_equals(address_to_select, disabled: true)
        end

        it "should list all 5 addresses" do
          expected = (addresses + international_addresses).map(&:id)
          view.billing_address.assert_saved_ids(expected)
        end

        it "should pre populate the billing address when a predefined address is selected then just use it if the user hasnt changed it" do
          view.shipping_address.select_from_saved(address_to_select) # Must always have a shipping address - so quickest way to get one
          view.billing_address.select_from_saved(address_to_select)
          view.select_shipping_method(shipping_method_id)
          view.assert_billing_address_equals(address_to_select, disabled: true)
          expect { view.submit! }.to_not change {customer_account.addresses.count}
          expect(updated_address.attributes).to eql address_to_select.attributes
          expect(new_transaction_page).to be_present
          expect(reloaded_cart.billing_address.id).to eql address_to_select.id
          expect(reloaded_cart.shipping_method.id).to eql shipping_method_id
        end


        it "should pre populate the shipping address when a predefined address is selected then let the user edit it and use it" do
          view.shipping_address.select_from_saved(address_to_select) # Must always have a billing address - so quickest way to get one
          view.billing_address.select_from_saved(address_to_select)
          view.assert_billing_address_equals(address_to_select, disabled: true)
          view.billing_address.allow_edit!
          view.billing_address.update_entry! new_address
          view.select_shipping_method(shipping_method_id)
          previous_address_count = customer_account.addresses.count
          view.submit!
          expect(new_transaction_page).to be_present
          expect(customer_account.addresses.count).to eql previous_address_count
          expect(updated_address.attributes).to include new_address.attributes
          expect(reloaded_cart.billing_address.id).to eql address_to_select.id
          expect(reloaded_cart.shipping_method.id).to eql shipping_method_id
          expect(reloaded_cart.billing_address.attributes.except(:id, :customer_account_id, :updated_at, :created_at)).to eql(new_address.attributes)
        end

        it "should create a new billing address and use it when the user wishes to use their own" do
          view.shipping_address.select_from_saved(address_to_select) # Must always have a shipping address - so quickest way to get one
          view.billing_address.update_entry! new_address
          view.select_shipping_method(shipping_method_id)
          expect {
            view.submit!
            expect(new_transaction_page).to be_present
          }.to change {customer_account.addresses.count}.by(1)
          expect(reloaded_cart.billing_address.id).to be_a(String)
          expect(reloaded_cart.shipping_method.id).to eql shipping_method_id
        end

        it "should reset the fields to empty when the user switches back to manual" do
          view.billing_address.select_from_saved(address_to_select) # Must always have a shipping address - so quickest way to get one
          view.assert_billing_address_equals(address_to_select, disabled: true)
          view.billing_address.select_manual!
          view.billing_address.assert_all_fields_empty
        end

        it "should disable the fields when the user selects a pre defined address" do
          view.billing_address.select_from_saved(address_to_select) # Must always have a shipping address - so quickest way to get one
          view.billing_address.assert_all_fields_disabled
        end
      end

      #
      # Shipping Address
      #
      context "shipping address" do
        it "should pre populate the shipping address when a predefined address is selected." do
          view.billing_address.select_from_saved(address_to_select) # Must always have a billing address - so quickest way to get one
          view.shipping_address.select_from_saved(address_to_select)
          view.assert_shipping_address_equals(address_to_select, disabled: true)
        end
        it "should list the non international addresses" do
          expected = (addresses).map(&:id)
          view.shipping_address.assert_saved_ids(expected)
        end

        it "should pre populate the shipping address when a predefined address is selected then just use it if the user hasnt changed it" do
          view.billing_address.select_from_saved(address_to_select) # Must always have a billing address - so quickest way to get one
          view.shipping_address.select_from_saved(address_to_select)
          view.assert_shipping_address_equals(address_to_select, disabled: true)
          view.select_shipping_method(shipping_method_id)
          expect { view.submit! }.to_not change {customer_account.addresses.count}
          expect(updated_address.attributes).to eql address_to_select.attributes
          expect(new_transaction_page).to be_present
          expect(reloaded_cart.shipping_address.id).to eql address_to_select.id
          expect(reloaded_cart.shipping_method.id).to eql shipping_method_id
        end

        it "should pre populate the shipping address when a predefined address is selected then let the user edit it and use it" do
          view.billing_address.select_from_saved(address_to_select) # Must always have a billing address - so quickest way to get one
          view.shipping_address.select_from_saved(address_to_select)
          view.assert_shipping_address_equals(address_to_select, disabled: true)
          view.shipping_address.allow_edit!
          view.shipping_address.update_entry! new_address
          view.select_shipping_method(shipping_method_id)
          previous_address_count = customer_account.addresses.count
          view.submit!
          expect(new_transaction_page).to be_present
          expect(reloaded_cart.shipping_address.id).to eql address_to_select.id
          expect(reloaded_cart.shipping_method.id).to eql shipping_method_id
          expect(reloaded_cart.shipping_address.attributes.except(:id, :customer_account_id, :created_at, :updated_at)).to eql(new_address.attributes)
        end

        it "should create a new shipping address and use it when the user wishes to use their own" do
          view.billing_address.select_from_saved(address_to_select) # Must always have a billing address - so quickest way to get one
          view.shipping_address.update_entry! new_address
          view.select_shipping_method(shipping_method_id)
          expect {
            view.submit!
            expect(new_transaction_page).to be_present
          }.to change {customer_account.addresses.count}.by(1)
          expect(reloaded_cart.shipping_address.id).to be_a(String)
          expect(reloaded_cart.shipping_method.id).to eql shipping_method_id
        end

        it "should reset the fields to empty when the user switches back to manual" do
          view.shipping_address.select_from_saved(address_to_select) # Must always have a shipping address - so quickest way to get one
          view.assert_shipping_address_equals(address_to_select, disabled: true)
          view.shipping_address.select_manual!
          view.shipping_address.assert_all_fields_empty
        end

        it "should disable the fields when the user selects a pre defined address" do
          view.shipping_address.select_from_saved(address_to_select) # Must always have a shipping address - so quickest way to get one
          view.shipping_address.assert_all_fields_disabled
        end
      end

      # Shipping Methods
      it "should have a shipping method field populated with the correct options" do
        view.assert_shipping_methods([shipping_method_id])
      end


      context "with validation errors" do
        let(:errors) { { address_line_1: ["Address line 1 can't be blank"]  } }
        it "should show validation errors if the billing address given is invalid" do
          view.billing_address.update_entry!(new_invalid_address)
          expect { view.submit! }.not_to change {customer_account.addresses.count}
          view.billing_address.assert_validation_errors(errors)
        end
        it "should show validation errors if the shipping address given is invalid" do
          view.billing_address.select_from_saved(address_to_select) # Must always have a billing address - so quickest way to get one
          view.shipping_address.update_entry!(new_invalid_address)
          expect { view.submit! }.not_to change {customer_account.addresses.count}
          view.shipping_address.assert_validation_errors(errors)
        end
        it "should show validation errors if the shipping and billing addresses given are invalid" do
          view.billing_address.update_entry!(new_invalid_address)
          view.shipping_address.update_entry!(new_invalid_address)
          expect { view.submit! }.not_to change {customer_account.addresses.count}
          view.shipping_address.assert_validation_errors(errors)
          view.billing_address.assert_validation_errors(errors)
        end
        it "should show validation errors if the shipping method is omitted" do
          view.billing_address.select_from_saved(address_to_select) # Must always have a billing address - so quickest way to get one
          view.shipping_address.update_entry!(new_invalid_address)
          expect { view.submit! }.not_to change {customer_account.addresses.count}
          view.shipping_address.assert_validation_errors(errors)
        end

      end
    end
    context "while not logged in" do
      let!(:cart) { mock_server.create_basket variants: variants }
      let(:new_address) { build(:address) }
      it "should create a new billing and shipping address and use it" do
        view.shipping_address.update_entry! new_address
        view.billing_address.update_entry! new_address
        view.email_address = attributes_for(:account)[:email]
        view.select_shipping_method(shipping_method_id)
        view.submit!
        expect(new_transaction_page).to be_present
        expect(reloaded_cart.billing_address.id).to be_a(String)
        expect(reloaded_cart.shipping_method.id).to eql shipping_method_id
      end
    end
    context "when another user buys the stock during checkout" do
      # @TODO It would be preferred to somehow decrease the stock of something via the API, but at the moment
      # it is not possible.
      let!(:products) { FlexCommerce::Product.paginate(per_page: 10, page: 2).all }
      let(:out_of_stock_response) do
        {
            data: variants.map.with_index { |v, idx| { id: v.sku, type: "stock_levels", attributes: { stock_available: idx } } }
        }
      end
      let!(:cart) { mock_server.create_basket variants: variants }
      let!(:stub) { stub_request(:get, /\/stock_levels\.json_api/).to_return body: out_of_stock_response.to_json, headers: { 'Content-Type': 'application/vnd.api+json' } }
      it "should highlight the out of stock items and not allow the user to progress" do
        view.assert_out_of_stock!
        view.assert_submit_button_disabled!
      end
    end
  end
end
