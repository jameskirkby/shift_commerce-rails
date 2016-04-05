require 'rails_helper'

RSpec.feature "New Transaction Spec", type: :feature, js: true, vcr: false, payment: true do
  include_context "global pages context"
  let!(:products) { FlexCommerce::Product.paginate(per_page: 10, page: 1).all }
  let(:variants) { products[0..9].map { |p| FlexCommerce::Product.find(p.slug).variants.first } }
  let(:shipping_method) { FlexCommerce::ShippingMethod.all.first }
  let(:starting_page) { page_object_for("new_transaction") }
  let(:paypal_page) { page_object_for("paypal_entrance").attach }
  let(:order_page) { page_object_for("order").attach }
  subject { starting_page.visit }
  shared_examples "pay by paypal" do
    it "should allow logging in to paypal and paying" do
      subject.view.select_paypal
      expect(paypal_page).to be_present
      paypal_page.view.assert_order_contents_present(cart: cart)
      paypal_page.view.login!(email: paypal_email, password: paypal_password)
      paypal_page.view.assert_shipping_address_correct(cart: cart)
      paypal_page.view.paypal_review.submit!
      expect(order_page).to be_present
    end
  end
  context "with a customer account" do
    let!(:customer_account) do
      mock_server.add_basic_customer_account!
    end
    after(:each) { customer_account.destroy rescue nil }
    let!(:billing_address) { create(:address, customer_account_id: customer_account.id) }
    let!(:shipping_address) { create(:address, customer_account_id: customer_account.id) }
    let!(:cart) { mock_server.create_basket variants: variants, customer_account_id: customer_account.id, total: 10.0, billing_address_id: billing_address.id, shipping_address_id: shipping_address.id, shipping_method_id: shipping_method.id }
    before(:each) { mock_server.login!(customer_account) }
    context "paypal" do
      include_examples "pay by paypal"
      context "with a non free shipping method" do
        let(:shipping_method) { FlexCommerce::ShippingMethod.all.last }
        include_examples "pay by paypal"
      end
    end

    context "spreedly" do
      let(:spreedly) { subject.view.spreedly }
      it "should take payment" do
        subject.view.select_spreedly
        spreedly.pay_with_test_card
        expect(order_page).to be_present
      end
    end

    context "secure trading" do
      let!(:billing_address) { create(:address,
                                      title: "Mr",
                                      first_name: "Gary",
                                      middle_names: "TheWildOne",
                                      last_name: "Taylor",
                                      customer_account_id: customer_account.id,
                                      address_line_1: "26 Reginald Road South",
                                      address_line_2: "Chaddesden",
                                      city: "Derby",
                                      postcode: "DE21 6ND",
                                      contact_number: "07445 809233",
                                      contact_number_type: "M"
      ) }
      let!(:shipping_address) { create(:address,
                                       title: "Mr",
                                       first_name: "Gary",
                                       middle_names: "TheWildOne",
                                       last_name: "Taylor",
                                       customer_account_id: customer_account.id,
                                       address_line_1: "26 Reginald Road South",
                                       address_line_2: "Chaddesden",
                                       city: "Derby",
                                       postcode: "DE21 6ND",
                                       contact_number: "07445 809233",
                                       contact_number_type: "M"
      ) }
      let(:secure_trading) { subject.view.secure_trading }
      let(:variants) { products[0..0].map { |p| FlexCommerce::Product.find(p.slug).variants.first } }

      it "should take payment" do
        subject.view.select_secure_trading
        secure_trading.select_payment_type("Visa")
        secure_trading.pay_with_test_card
        expect(order_page).to be_present
      end
    end

  end
  context "anonymous" do
    let!(:billing_address) { create(:address) }
    let!(:shipping_address) { create(:address) }
    let(:email_address) { attributes_for(:account)[:email] }
    let!(:cart) { mock_server.create_basket variants: variants, total: 10.0, billing_address_id: billing_address.id, shipping_address_id: shipping_address.id, shipping_method_id: shipping_method.id, email: email_address }
    context "paypal" do
      include_examples "pay by paypal"
    end
  end

end
