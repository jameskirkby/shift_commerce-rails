require 'rails_helper'

RSpec.feature "Product Specs", type: :feature, js: true do
  include ActiveSupport::NumberHelper
  include_context "global pages context"
  let!(:products) {
    ::FlexCommerce::Product.where(filter: {"in_stock" => {"eq" => true}}).includes(:variants).paginate(per_page: 10, page: 1).all
  }
  let(:product) { ::FlexCommerce::Product.find("slug:#{products.first.slug}") }
  subject { page_object_for("product", product: product).visit }
  it_should_behave_like "any site page" # Verifies common requirements across all pages


  context "with a product with multiple variants" do
    it "should display key attributes from the product apart from the price which comes from the variant" do
      expect(subject.product_view.title).to have_text product.title
      expect(subject.product_view.price).to have_text number_to_currency(product.variants.first.price.round(2), unit: default_currency)
      expect(subject.product_view.description).to have_text product.description
    end

    it "should present the user with a choice of variants" do
      expect(subject.product_view.variant_selector).to be_present
      expect(subject.product_view.variant_selector.titles).to eql product.variants.map {|v| "#{v.title} - #{number_to_currency(v.price, unit: default_currency)}"}
    end

    context "starting with empty basket" do
      let!(:cart) { mock_server.create_basket }
      let(:line_items) { mock_server.line_items_for_cart(cart.id) }

      it "should add the first variant to basket" do
        subject.product_view.add_to_basket!
        expect(page).to have_content("Added to basket")
        expect(line_items.length).to eql 1
        expect(line_items.first.item_id).to eql product.variants.first.id.to_i
        expect(line_items.first.item_type).to eql "Variant"
        expect(line_items.first.unit_quantity).to eql 1
      end

      it "should add the second variant to basket" do
        subject.product_view.variant_selector.select product.variants[1].title
        subject.product_view.add_to_basket!
        expect(page).to have_content("Added to basket")
        expect(line_items.length).to eql 1
        expect(line_items.first.item_id).to eql product.variants[1].id.to_i
        expect(line_items.first.item_type).to eql "Variant"
        expect(line_items.first.unit_quantity).to eql 1
      end

      it "should add the first variant to the basket with quantity of 2" do
        subject.product_view.add_to_basket! quantity: 2
        expect(page).to have_content("Added to basket")
        expect(line_items.length).to eql 1
        expect(line_items.first.item_id).to eql product.variants.first.id.to_i
        expect(line_items.first.unit_quantity).to eql 2
      end
      it "should provide feedback if a 422 is returned from the server" do
        fake_body = {"errors":[{"detail":"Cart max total quantity exceeded","title":"Cart max total quantity exceeded","source":{"pointer":"cart"}}]}
        stub_request(:post, /v1\/line_items\.json_api/).to_return body: fake_body.to_json, headers: { "Content-Type" => "application/vnd.api+json" }, status: 422
        subject.product_view.add_to_basket! quantity: 2
        expect(page).not_to have_content("Added to basket")
        expect(page).to have_content "Cart max total quantity exceeded"

      end
      it "should provide feedback if something has gone out of stock when the user adds it"
    end
  end
  context "a product with a template definition and template attributes" do
    let(:product) { ::FlexCommerce::Product.find("slug:seed_product_12") }
    # We wouldn't normally have selenium type of things in here - it should be done in the
    # page objects, however, in this case, the html that we are testing for is really part
    # of the test itself, so it is quite valid - as we are testing to make sure the HTML output
    # hasnt been escaped.
    #
    # Also, for this test to make sense, you should know that the seed data in flex is setup
    # so that every 10 products starting at the second is setup to use the "Product" template
    # definition which is configured with a "colour" attribute (HTML Editor!) and a "size"
    # attribute (integer) - the values are "<div class='red'></div>" and 7 respectively
    it "should display with the correct template" do
      view = subject.product_view_for_example_template
      expect(view.title_node).to have_text product.title
      expect(view.colour_node).to have_text "red"
      expect(view.colour_node).to have_selector(:css, ".red")
      expect(view.size_node).to have_text "7"
    end
  end
end
