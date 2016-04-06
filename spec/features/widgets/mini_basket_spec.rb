require 'rails_helper'
#
# This widget test tests a single instance of the widget, found on the specified "starting_page".
# it does not test every instance of the widget on all pages.
RSpec.feature "Widgets::MiniBasket", type: :feature, js: true do
  include_context "global widgets context"
  let(:widget) { widget_object_for.get "mini_basket" }
  let(:starting_page) { page_object_for("entrance").visit }
  let(:cart_page) { page_object_for("cart").attach }
  let(:checkout_page) { page_object_for("checkout").attach }
  # @TODO Paginate this - to only fetch th number of variants that are needed and error if not enough
  let!(:products) { FlexCommerce::Product.where(filter: {"in_stock" => {"eq" => true}}).paginate(per_page: 5, page: 1).all }
  let(:variant_list) { products[0..3].map { |p| FlexCommerce::Product.find("slug:#{p.slug}").variants.first } }

  # Here, we define the subject under test which is the mini basket
  # If the mini basket is not located in the header on the starting page, change to suit.
  subject do
    starting_page.visit.header.mini_basket
  end

  # The standard state is the state of the "starting_page" without doing anything such as logging in
  context "standard state" do
    include ActiveSupport::NumberHelper
    context "with an empty basket" do
      before(:each) { mock_server.create_basket }
      it "should not show a badge" do
        expect(subject.has_badge?).to be false
      end
      it "should show empty basket on hover", touch: false do
        subject.expand!
        expect(subject.basket_tooltip).to be_empty
      end
    end
    context "with items in the basket" do
      context "basic cart" do
        let!(:cart) { mock_server.create_basket variants: variants }
        context "with 1 item in the basket" do
          let(:variants) { variant_list.slice(0, 1) }
          it "should have a badge showing '1'" do
            expect(subject.has_badge?).to be true
            expect(subject.badge_text).to eql "1"
          end
          it "should show 1 item in the basket on expand", touch: true do
            subject.expand!
            expect(subject.basket_tooltip).not_to be_empty
            # @TODO Once delivery costs are available, this will need to change
            expect(subject.basket_tooltip.row_count).to eql 1
          end
          it "should show the correct price of the basket on hover", touch: true do
            subject.expand!
            expect(subject.basket_tooltip.total).to have_content number_to_currency(variants.map(&:price).sum, unit: default_currency)
          end
          it "should provide a means to edit the basket" do
            subject.expand!
            subject.basket_tooltip.edit_cart!
            expect(cart_page).to be_present
          end
          it "should provide a means to go to the checkout" do
            subject.expand!
            subject.basket_tooltip.checkout!
            expect(checkout_page).to be_present
          end
        end
        context "with 2 items in the basket" do
          let(:variants) { variant_list.slice(0, 2) }
          it "should have a badge showing '2'" do
            expect(subject.has_badge?).to be true
            expect(subject.badge_text).to eql "2"
          end
          it "should show 2 item in the basket on hover", touch: true do
            subject.expand!
            expect(subject.basket_tooltip.row_count).to eql 2
          end
          it "should show the correct price of the basket on hover", touch: true do
            subject.expand!
            expect(subject.basket_tooltip.total).to have_content number_to_currency(variants.map(&:price).sum, unit: default_currency)
            expect(subject.basket_tooltip.sub_total).to have_content number_to_currency(variants.map(&:price).sum, unit: default_currency)
          end
        end

      end
      context "with promotions applied" do
        let!(:promotion) do
          mock_server.delete_all_promotions
          mock_server.create_promotion_for_all_orders
        end
        let!(:cart) { mock_server.create_basket variants: variants }
        context "with 2 items in the basket" do
          let(:variants) { variant_list.slice(0, 2) }
          it "should show the correct discount summaries of the basket on hover", touch: true do
            subject.expand!
            expect(subject.basket_tooltip.discount_summary_row_at_index(0).total_node).to have_content("1.50")
            expect(subject.basket_tooltip.discount_summary_row_at_index(0).name_node).to have_content("£1.50 off all orders")
          end
        end

      end
    end
  end
end
