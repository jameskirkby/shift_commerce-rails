require 'rails_helper'

RSpec.feature "Cart Specs", type: :feature, js: true do
  include_context "global pages context"
  let(:starting_page) { page_object_for("cart") }
  let(:checkout_page) { page_object_for("checkout") }
  before(:each) { FlexCommerce::Promotion.all.each(&:destroy) }
  subject { starting_page.visit }
  it_should_behave_like "any site page" # Verifies common requirements across all pages
  context "with an empty cart" do
    it "should inform the user that the basket is empty" do
      expect(subject.view).to be_empty
    end
  end
  context "with 10 entries in cart" do
    let!(:products) { FlexCommerce::Product.where(filter: {"in_stock" => {"eq" => true}}).paginate(per_page: 10, page: 1).all }
    let(:variants) { products[0..9].map { |p| FlexCommerce::Product.find("slug:#{p.slug}").variants.first } }
    context "basic cart" do
      let!(:cart) { mock_server.create_basket variants: variants }
      it "should show 10 items" do
        subject.view.assert_line_item_quantity variants.length
      end
      it "should contain the title, price, quantity and total for each line item" do
        variants.each_with_index do |variant, idx|
          subject.view.within_row(idx) do |row|
            expect(row.title_node).to have_content variant.title
            expect(row.price_node).to have_content variant.price
            expect(row.total_node).to have_content variant.price
            expect(row.quantity_node).to have_content "1"
          end
        end
      end
      it "should allow the user to increase the quantity on one of the rows" do
        variant = variants[1]
        subject.view.increase_quantity_for_row(1)
        expect(page).to have_content(I18n.t("carts.show.update"))
        subject.view.within_row(1) do |row|
          expect(row.quantity_node).to have_content("2")
          expect(row.total_node).to have_content(variant.price * 2)
        end
      end
      it "should display an error if an attempted increase responds with a 422 from the API" do
        fake_body = {"errors":[{"detail":"Cart max total quantity exceeded","title":"Cart max total quantity exceeded","source":{"pointer":"cart"}}]}
        stub_request(:patch, /v1\/line_items\/(\d*)\.json_api/).to_return body: fake_body.to_json, headers: { "Content-Type" => "application/vnd.api+json" }, status: 422
        variant = variants[1]
        subject.view.increase_quantity_for_row(1)
        expect(page).not_to have_content(I18n.t("carts.show.update"))
        expect(page).to have_content "Cart max total quantity exceeded"
      end
      it "should allow the user to decrease the quantity on one of the rows therefore removing it" do
        subject.view.decrease_quantity_for_row(1)
        expect(page).to have_content(I18n.t("carts.show.update"))
        subject.view.assert_line_item_quantity variants.length - 1
      end
      it "should show the sub total and total" do
        expect(subject.view.summary.sub_total_node).to have_content("£#{variants.map(&:price).sum.round(2)}")
        expect(subject.view.summary.total_node).to have_content("£#{variants.map(&:price).sum.round(2)}")
      end

      it "should have a checkout link" do
        expect(subject.view.checkout!)
        expect(checkout_page).to be_present
      end
    end
    context "when user is logged in" do
      let(:customer_account) { create(:account) }
      let!(:cart) { mock_server.create_basket variants: variants, customer_account_id: customer_account.id }
      after(:each) { customer_account.destroy rescue nil }
      let(:paypal_page) { page_object_for("paypal_entrance").attach }
      let(:order_page) { page_object_for("order").attach }

      it "should allow logging in to paypal and paying" do
        subject.view.select_paypal
        expect(paypal_page).to be_present
        paypal_page.view.assert_order_contents_present(cart: cart)
        paypal_page.view.login!(email: paypal_email, password: paypal_password)
        paypal_page.view.paypal_review.submit!
        expect(order_page).to be_present
      end
      it "should allow logging in to paypal and paying using a shipping method from paypal" do
        subject.view.select_paypal
        shipping_method = ::FlexCommerce::ShippingMethod.all.sort {|a, b| a.price <=> b.price}.last
        expect(paypal_page).to be_present
        paypal_page.view.assert_order_contents_present(cart: cart)
        paypal_page.view.login!(email: paypal_email, password: paypal_password)
        paypal_page.view.paypal_review.wait_until_ready
        paypal_page.view.paypal_review.select_shipping_method(shipping_method)
        paypal_page.view.paypal_review.submit!
        expect(order_page).to be_present
        order_page.view.assert_shipping_method(shipping_method)
      end

    end
    context "when user is not logged in" do
      let(:paypal_page) { page_object_for("paypal_entrance").attach }
      let(:order_page) { page_object_for("order").attach }
      context "with no shipping method" do
        let!(:cart) { mock_server.create_basket variants: variants }

        it "should allow logging in to paypal and paying" do
          subject.view.select_paypal
          expect(paypal_page).to be_present
          paypal_page.view.assert_order_contents_present(cart: cart)
          paypal_page.view.login!(email: paypal_email, password: paypal_password)
          paypal_page.view.paypal_review.submit!
          expect(order_page).to be_present
        end
      end
      context "with a shipping method" do
        let(:shipping_method) { ::FlexCommerce::ShippingMethod.all.last }
        let!(:cart) { mock_server.create_basket variants: variants, shipping_method_id: shipping_method.id }

        it "should allow logging in to paypal and paying" do
          subject.view.select_paypal
          expect(paypal_page).to be_present
          paypal_page.view.assert_order_contents_present(cart: cart)
          paypal_page.view.login!(email: paypal_email, password: paypal_password)
          paypal_page.view.paypal_review.submit!
          expect(order_page).to be_present
        end
      end



    end


    context "with promotion" do
      let!(:promotion) do
        mock_server.delete_all_promotions
        mock_server.create_promotion_for_all_orders
      end
      let!(:cart) { mock_server.create_basket variants: variants }
      it "should show 1 discount summary" do
        subject.view.assert_discount_summary_quantity 1
      end

      it "should show the correct discount summary" do
        expect(subject.view.discount_summary_row_at_index(0).total_node).to have_content("1.50")
        expect(subject.view.discount_summary_row_at_index(0).name_node).to have_content("£1.50 off all orders")
      end
    end

    context "applying promotions" do
      let!(:promotion) do
        mock_server.delete_all_promotions
        mock_server.create_coupon
      end
      let!(:cart) { mock_server.create_basket variants: variants }
      it "should apply a promotion to the cart" do
        subject.view.add_coupon!(promotion.coupon_code)
        expect(page).to have_content(I18n.t("carts.show.coupon_applied"))
        expect(subject.view.discount_summary_row_at_index(0).total_node).to have_content(promotion.discount_amount)
        expect(subject.view.discount_summary_row_at_index(0).name_node).to have_content(promotion.name)
      end
      it "should present the user with an error if a wrong promotion is used" do
        subject.view.add_coupon!("#{promotion.coupon_code}_wrong")
        expect(page).to have_content(I18n.t("carts.show.invalid_coupon"))
      end
    end
  end
end
